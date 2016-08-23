# Chef Server and Hashicorp Vault
#
# Both rely on shell scripts in respective folders for provisioning.
#
# NOTE: Make sure you have the centos/7 base box installed...
# vagrant box add centos/7

Vagrant.configure("2") do |config|
  config.vm.define "chef-server" do |chef|
    chef.vm.box = "centos/7"
    chef.vm.hostname = "chef.centos.box"
    chef.vm.network :private_network, ip: "192.168.0.42"
    chef.vm.provider :virtualbox do |vb|
      vb.memory = 4000
      vb.cpus = 4
    end
    chef.vm.provision "shell" do |s|
      s.args = [config.vm.hostname, 'ADMIN@EMAIL.HERE']
      s.path = "ChefServer/install-chef.sh"
    end
  end
  config.vm.define "hashicorp-vault" do |vault|
    vault.vm.box = "centos/7"
    vault.vm.hostname = "vault.centos.box"
    vault.vm.network :private_network, ip: "192.168.0.43"
    vault.vm.network "forwarded_port", guest: 8200, host: 8200
    vault.vm.provider :virtualbox do |vb|
      vb.memory = 256
    end
    vault.vm.provision "shell" do |s|
      s.path = "HashicorpVault/install-vault.sh"
    end
  end
end
