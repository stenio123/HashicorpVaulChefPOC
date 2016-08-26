# installs chef client
# connects to chef (parameter passed by vagrant manually)
# pass the vault token manually
# does the consul template thing https://www.hashicorp.com/blog/using-hashicorp-vault-with-chef.html

# Allows Chef workstation to bootstrap
cat /home/vagrant/ssh/id_rsa.pub | cat >>  ~/.ssh/authorized_keys

# Allows connection to Chef Server
sudo chmod 706 /etc/hosts
echo '192.168.0.43 chef.centos.box' >> /etc/hosts
