# Hashicorp Vault + Chef Server POC

### This is a demo showing how to integrate Hashicorp Vault with Chef Server to manage secrets.

### This project uses insecure configuration, it is intended for educational purposes only.

### Requirements
- Tested with Vagrant 1.8.1
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed
- Enough RAM if running all VMs

If you already have Chef Server with Nodes running, move to the _Hashicorp Vault_ section below.

## Chef Server
### Installation
1. Go to the Chef folder and start the VMs

    ````
    cd Chef
    vagrant up
    ````
2. Chef Server should take about 15 minutes to complete installation
3. Once done, open a browser and go to _https://192.168.0.43_
4. Login with _admin_ and _password_
5. The Chef workstation will ensure the Node is added to Chef Server.

### Note: Hardcoded Variables
If you change these values on the Vagrantfile, ensure that they are changed across the project since there are dependencies. TODO - convert into variables.

- ip: 192.168.0.42
- hostname: chef.centos.box
- organization name: org
- username: admin
- password: password


## Hashicorp Vault
### Installation
1. Go to the HashicorpVault folder and start the VMs

    ````
    cd HashicorpVault
    vagrant up
    ````
### Manual steps to initialize the Vault (only needed once)
#### Unseal
1. Execute to log into the VM

    ````
    vagrant ssh hashicorp-vault
    ````
2. Execute

    ````
    vault init
    ````
3. Write down the generated tokens, which will be needed to seal/unseal the vault in the future
4. Execute this command three times, entering one of the provided tokens:

    ````
    vault unseal
    ````
#### Enable AppRole Authentication
1. Authenticate using root token provided at start:

    ````
    vault auth [root token]
    ````
2. Execute to enable AppRole authentication:

    ```
    ./vault auth-enable approle
    ```

#### Add policies
Execute:

```
./vault policy-write production sync/policies/production.hcl
./vault policy-write qa sync/policies/qa.hcl
./vault policy-write development sync/policies/development.hcl
```
#### Create a token that is associated with a policy
Execute:

```
./vault token-create -policy="production"
```

#### Write a secret
Execute:

```
./vault write secret/production/password value=MyPassword
```

## FAQ
1. How to associate a policy with a user?

   Policies described here https://www.vaultproject.io/docs/concepts/policies.html.
The way to associate a certain policy with a user will vary on the Authentication backend. For tokens, it is associated during token creation time through a parameter.
For example, once policy "production" has been created, this command will generate a token associated with that policy and with TTL of 720 hours:
    ````
    ./vault token-create -policy="production"
    ````

2. How to automate Vault initialization?

   Unclear as to where to store those tokens and run initial sequence of commands.

3. How do Chef Nodes authenticate agains Vault?

   Documentation points to the user of AppRole Auth backend. It suggests the use of 'hard to guess' UIID, such as MAC address.
   Chef might be able to do that during bootstrap by accessing OHAI attributes. But then unclear how Chef authenticates with Vault to create AppRole users for Nodes.

4. How to initialize secrets on Vault, how to add new secret?

5. How do you manage the secrets? Shouldn't there be a list of the available secrets, not necessarily the sensitive information, but at least the keys they are associated with.
