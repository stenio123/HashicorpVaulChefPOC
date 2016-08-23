# Hashicorp Vault + Chef Server POC

This is a demo showing how to integrate Hashicorp Vault with Chef Server to manage secrets.

To run:

1. Ensure you have VirtualBox installed
2. Go to each folder and execute "_vagrant up_"
3. Chef Server should take about 15 minutes to complete installation


## Chef Server
1. Once done, open a browser and go to _https://192.168.0.42_
2. Login with _admin_ and _password_ 

## Hashicorp Vault
1. Execute _vagrant ssh_ to log into the VM
2. Execute _vault init_
3. Write down the generated tokens, which will be needed to seal/unseal the vault in the future
