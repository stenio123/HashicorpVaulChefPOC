### Installs and Configures Chef Workstation

yum install curl wget screen -y
echo "Fetching chefdk installer..."
wget -q https://packages.chef.io/stable/el/7/chefdk-0.17.17-1.el7.x86_64.rpm
echo "Installing chef..."
rpm -Uvh chefdk-0.17.17-1.el7.x86_64.rpm

# Creates chef-repo
mkdir -p /home/vagrant/chef-repo/.chef
chmod 777 /home/vagrant/chef-repo/.chef

# Sets ssh keys to allow communication with Chef Server
cp -r /home/vagrant/sync/ssh /home/vagrant/
chmod 600 /home/vagrant/.ssh/id_rsa

# Copies validation keys from Chef server to allow communication
scp -i .ssh/id_rsa -oStrictHostKeyChecking=no vagrant@192.168.0.43:/tmp/admin.pem /home/vagrant/chef-repo/.chef
scp -i .ssh/id_rsa -oStrictHostKeyChecking=no vagrant@192.168.0.43:/tmp/org-validator.pem /home/vagrant/chef-repo/.chef
cp /home/vagrant/sync/ChefWorkstation/knife.rb /home/vagrant/chef-repo/.chef

# Installs Chef Server certificates
knife ssl fetch

# Points to the correct Chef Server address
sudo chmod 706 /etc/hosts
echo '192.168.0.43 chef.centos.box' >> /etc/hosts
# Bootstraps Node
knife bootstrap vagrant@192.168.0.44 -i ~/.ssh/id_rsa --sudo --use-sudo-password
