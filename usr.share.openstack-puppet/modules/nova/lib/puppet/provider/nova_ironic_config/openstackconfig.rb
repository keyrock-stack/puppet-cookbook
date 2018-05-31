Puppet::Type.type(:nova_ironic_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/nova/nova-ironic.conf'
  end

end
