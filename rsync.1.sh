#
# Step 2
#
#rsync -avz /folk/lkwan/public/cgts4/keystone.py wrsroot@10.10.10.2:/usr/lib64/python2.7/site-packages/sysinv/puppet/keystone.py
rsync -avz /folk/lkwan/public/cgts4/puppet-manifests/src/modules/openstack/manifests/keystone.pp wrsroot@10.10.10.2:/usr/share/puppet/modules/openstack/manifests/keystone.pp
rsync -avz /folk/lkwan/public/cgts4/puppet-manifests/src/modules/openstack/templates/ wrsroot@10.10.10.2:/usr/share/puppet/modules/openstack/templates/
