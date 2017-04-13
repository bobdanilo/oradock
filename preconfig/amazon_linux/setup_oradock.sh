#!/bin/bash
oradock_home=/opt/oradock
chef_base=/root

source ~/.bash_profile

#creating cookbook oradock_chef
chef gerenate cookbook ${chef_base}/chef-repo/cookbooks/oradock_chef

#copying rb files to oradock_chef cookbook
mkdir -p ${chef_base}/chef-repo/cookbooks/oradock_chef/attributes
yes | cp ${oradock_home}/preconfig/amazon_linux/chef_config/attributes/oradock.rb ${chef_base}/chef-repo/cookbooks/oradock_chef/attributes/oradock.rb
yes | cp ${oradock_home}/preconfig/amazon_linux/chef_config/recipes/*.rb ${chef_base}/chef-repo/cookbooks/oradock_chef/recipes/
yes | cp ${oradock_home}/preconfig/amazon_linux/chef_config/metadata.rb ${chef_base}/chef-repo/cookbooks/oradock_chef/metadata.rb

#downloading dependents cookbooks
knife cookbook site download yum 5.0.1 -f ${chef_base}/chef-repo/cookbooks/yum-5.0.1.tar.gz
knife cookbook site download filesystem 0.10.0 -f ${chef_base}/chef-repo/cookbooks/filesystem-0.10.0.tar.gz
knife cookbook site download lvm 1.1.0 -f ${chef_base}/chef-repo/cookbooks/lvm-1.1.0.tar.gz
git clone https://github.com/sds/chef-pyenv ${chef_base}/chef-repo/cookbooks/pyenv
tar -xzf ${chef_base}/chef-repo/cookbooks/yum-5.0.1.tar.gz
tar -xzf ${chef_base}/chef-repo/cookbooks/filesystem-0.10.0.tar.gz
tar -xzf ${chef_base}/chef-repo/cookbooks/lvm-1.1.0.tar.gz
rm -f ${chef_base}/chef-repo/cookbooks/*.tar.gz

#copy json file attributes
cp ${oradock_home}/preconfig/amazon_linux/chef_config/oradock.json ${chef_base}/oradock.json

#run chef recepies
chef-solo -c ${chef_base}/chef-repo/solo.rb -j ${chef_base}/oradock.json
