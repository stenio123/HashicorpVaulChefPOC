### Set Hostname
hostname $1

### Install Chef Server
yum install curl wget screen -y
echo "Fetching chef installer..."
wget -q https://packages.chef.io/stable/el/6/chef-server-core-12.6.0-1.el6.x86_64.rpm
echo "Installing chef..."
rpm -Uvh chef-server-core-12.6.0-1.el6.x86_64.rpm
chef-server-ctl reconfigure
chef-server-ctl user-create admin Name Last $2 'password' --filename /tmp/admin.pem
chef-server-ctl org-create org 'Organization' --association_user admin --filename /tmp/org-validator.pem
# store keys in artifact repository
# curl -u $admin:$password -X PUT www.repository.com/admin.key -T /tmp/admin.key
# curl -u $admin:$password -X PUT www.repository.com/validation.pem -T /tmp/org-validator.pem

# Add Chef Management UI Add-on (free for <25 nodes)
chef-server-ctl install chef-manage
chef-server-ctl reconfigure
chef-manage-ctl reconfigure --accept-license
# Add Chef Push Jobs (Nodes don't need to have Chef installed)
chef-server-ctl install opscode-push-jobs-server
chef-server-ctl reconfigure
opscode-push-jobs-server-ctl reconfigure
# Add Chef Reporting Add-on
# chef-server-ctl install opscode-reporting
# chef-server-ctl reconfigure
# opscode-reporting-ctl reconfigure --accept-license

# sets ssh keys to allow node communication
cat /home/vagrant/sync/ssh/id_rsa.pub | cat >>  ~/.ssh/authorized_keys
