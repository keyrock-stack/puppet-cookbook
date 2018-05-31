require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/glance')
require 'tempfile'
require 'net/http'

Puppet::Type.type(:glance_image).provide(
  :openstack,
  :parent => Puppet::Provider::Glance
) do
  desc <<-EOT
    Provider to manage glance_image type.
  EOT

  @credentials = Puppet::Provider::Openstack::CredentialsV3.new

  # TODO(flaper87): v2 is now the default. Force the use of v2,
  # to avoid supporting both versions and other edge cases.
  ENV['OS_IMAGE_API_VERSION'] = '2'

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def create
    temp_file = false
    if @resource[:source]
      # copy_from cannot handle file://
      if @resource[:source] =~ /^\// # local file
        location = "--file=#{@resource[:source]}"
      else
        temp_file = Tempfile.new('puppet-glance-image')

        uri = URI(@resource[:source])
        Net::HTTP.start(uri.host, uri.port,
                        :use_ssl => uri.scheme == 'https') do |http|
          request = Net::HTTP::Get.new uri
          http.request request do |response|
            open temp_file.path, 'w' do |io|
              response.read_body do |segment|
                io.write(segment)
              end
            end
          end
        end

        location = "--file=#{temp_file.path}"
      end

    # location cannot handle file://
    # location does not import, so no sense in doing anything more than this
    elsif @resource[:location]
      location = "--location=#{@resource[:location]}"
    else
      raise(Puppet::Error, "Must specify either source or location")
    end
    opts = [@resource[:name]]

    opts << (@resource[:is_public] == :true ? '--public' : '--private')
    opts << "--container-format=#{@resource[:container_format]}"
    opts << "--disk-format=#{@resource[:disk_format]}"
    opts << "--min-disk=#{@resource[:min_disk]}" if @resource[:min_disk]
    opts << "--min-ram=#{@resource[:min_ram]}" if @resource[:min_ram]
    opts << "--id=#{@resource[:id]}" if @resource[:id]
    opts << props_to_s(@resource[:properties]) if @resource[:properties]
    opts << location

    begin
      @property_hash = self.class.request('image', 'create', opts)
      @property_hash[:ensure] = :present
    ensure
      if temp_file
        temp_file.close(true)
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    self.class.request('image', 'delete', @resource[:name])
    @property_hash.clear
  end

  mk_resource_methods

  def is_public=(value)
    @property_flush[:is_public] = value
  end

  def is_public
    bool_to_sym(@property_hash[:is_public])
  end

  def disk_format=(value)
    @property_flush[:disk_format] = value
  end

  def container_format=(value)
    @property_flush[:container_format] = value
  end

  def min_ram=(value)
    @property_flush[:min_ram] = value
  end

  def min_disk=(value)
    @property_flush[:min_disk] = value
  end

  def properties=(value)
    @property_flush[:properties] = value
  end

  def id=(id)
    fail('id for existing images can not be modified')
  end

  def self.instances
    list = request('image', 'list', '--long')
    list.collect do |image|
      attrs = request('image', 'show', image[:id])
      properties = Hash[attrs[:properties].scan(/(\S+)='([^']*)'/)] rescue nil
      new(
        :ensure           => :present,
        :name             => attrs[:name],
        :is_public        => attrs[:visibility].downcase.chomp == 'public'? true : false,
        :container_format => attrs[:container_format],
        :id               => attrs[:id],
        :disk_format      => attrs[:disk_format],
        :min_disk         => attrs[:min_disk],
        :min_ram          => attrs[:min_ram],
        :properties       => properties
      )
    end
  end

  def self.prefetch(resources)
    images = instances
    resources.keys.each do |name|
      if provider = images.find{ |image| image.name == name }
        resources[name].provider = provider
      end
    end
  end

  def flush
    if @property_flush
      opts = [@resource[:name]]

      (opts << '--public') if @property_flush[:is_public] == :true
      (opts << '--private') if @property_flush[:is_public] == :false
      (opts << "--container-format=#{@property_flush[:container_format]}") if @property_flush[:container_format]
      (opts << "--disk-format=#{@property_flush[:disk_format]}") if @property_flush[:disk_format]
      (opts << "--min-ram=#{@property_flush[:min_ram]}") if @property_flush[:min_ram]
      (opts << "--min-disk=#{@property_flush[:min_disk]}") if @property_flush[:min_disk]
      (opts << props_to_s(@property_flush[:properties])) if @property_flush[:properties]

      self.class.request('image', 'set', opts)
      @property_flush.clear
    end
  end

  private

  def props_to_s(props)
    props.flat_map{ |k, v| ['--property', "#{k}=#{v}"] }
  end
end
