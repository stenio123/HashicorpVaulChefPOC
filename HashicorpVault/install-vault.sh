# Installs and starts Hashicorp vault

yum install wget -y
wget --quiet https://releases.hashicorp.com/vault/0.6.1/vault_0.6.1_linux_amd64.zip
yum install unzip -y
unzip vault_0.6.1_linux_amd64.zip
nohup ./vault server -config sync/config.hcl &
export VAULT_ADDR=http://127.0.0.1:8200
