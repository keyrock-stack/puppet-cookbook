#require 'puppet/provider/openstack/credentials'
require File.join(File.dirname(__FILE__), '..','..','..', 'puppet/provider/openstack/credentials')
require 'hiera_puppet'

module Puppet::Provider::Openstack::Auth

  RCFILENAME = "/etc/nova/openrc"

  def lookup_hiera(key)
    HieraPuppet.lookup(key, :undef, self, nil, :priority)
  end

  def get_admin_password
   value=lookup_hiera('keystone::admin_password')
   return value
  end

  def get_os_vars_from_env
    env = {}
    ENV.each { |k,v| env.merge!(k => v) if k =~ /^OS_/ }
    return env
  end

  def get_os_vars_from_rcfile(filename)
    env = {}
    rcfile = [filename, '/root/openrc'].detect { |f| File.exists? f }
    unless rcfile.nil?
      File.open(rcfile).readlines.delete_if{|l| l=~ /^#|^$/ }.each do |line|
        # we only care about the OS_ vars from the file LP#1699950
        if line =~ /OS_/ and line.include?('=')
          key, value = line.split('=')
          key = key.split(' ').last
          value = value.chomp.gsub(/'/, '')
          env.merge!(key => value) if key =~ /OS_/
        end
      end
    end
    return env
  end

  def rc_filename
    RCFILENAME
  end

  def request(service, action, properties=nil, options={})
    properties ||= []
    set_credentials(@credentials, get_os_vars_from_env)
    unless @credentials.set?
      @credentials.unset
      set_credentials(@credentials, get_os_vars_from_rcfile(rc_filename))
      # retrieves the password from hiera data since keyring is not yet available
      @credentials.password = get_admin_password
    end
    unless @credentials.set?
      raise(Puppet::Error::OpenstackAuthInputError, 'Insufficient credentials to authenticate')
    end
    super(service, action, properties, @credentials, options)
  end

  def set_credentials(creds, env)
    env.each do |key, val|
      var = key.sub(/^OS_/,'').downcase
      creds.set(var, val)
    end
  end
end
