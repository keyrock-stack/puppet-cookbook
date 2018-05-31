Puppet::Type.newtype(:compute_reserved_config) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Section/setting name to manage from compute_reserved.conf'
    newvalues(/\S*\/\S+/)
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |value|
      value = value.to_s.strip
      value.capitalize! if value =~ /^(true|false)$/i
      value
    end
  end

end
