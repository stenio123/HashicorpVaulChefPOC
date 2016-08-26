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
If you change these values on the Vagrantfile, ensure that they are changed across the project since there are dependencies.

TODO - convert into variables, since Vagrantfile is Ruby https://maci0.wordpress.com/2013/11/09/dynamic-multi-machine-vagrantfile/.

- ip: 192.168.0.43
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
    ./vault server -config=sync/config.hcl
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
2. Enable auditing log

    ```
    ./vault audit-enable file path=./vault_audit.log
    ```
3. Execute to enable AppRole authentication:

    ```
    ./vault auth-enable approle
    ```
4. Check existing secret 'folders':

    ```
    ./vault mounts
    ```
#### Add policies
Execute:

```
./vault policy-write production sync/policies/production.hcl
./vault policy-write qa sync/policies/qa.hcl
./vault policy-write development sync/policies/development.hcl
```

#### Write sample secrets
Execute:

```
./vault write secret/production/password value=MyProdPassword
./vault write secret/production/qa value=MyQAPassword
./vault write secret/production/development value=MyDevelopmentPassword
```

#### Bootstrapping to allow a Node/ app using tokens
1. Create token, and wrap results using Cubbyhole

   ```
   ./vault token-create -policy=production -wrap-ttl=20m
   ```

   *Optional arguments*
   _explicit_max_ttl_ - Sets the time after which this token can never be renewed.
   _num_uses_ - Number of times this token can be used. Default is unlimited.
   _renewable_ - If token is renewable or not. Default is true.
   _ttl_ - Time token is valid. Default is 720hs.

2. This returns a cubbyhole token with time to live. This is a single use token.
3. Send token to Node
4. Node issues

    ```
    curl \
        -H "X-Vault-Token: [cubbyhole token]" \
        -X GET \
        http://192.168.0.46:8200/v1/cubbyhole/response
    ```
    This will return a json containing the access token and lease renewal token.
    If returns permission denied, token either expired or compromised. Notify Vault to revoke that token and create a new one.
5. Now whenever Node wants to talk to Vault, it should use its token on the X-Vault-Token header
6. This token has ttl and will expire in 720hs. In order to keep alive, Node must issue
    ```
    curl \
        -H "X-Vault-Token: [token]" \
        -X POST \
        http://192.168.0.46:8200/v1/auth/token/renew-self
    ```
    Not that this is not the cubbyhole token, it is the token that was wrapped in that token.
    Lease renewal is only possible if token still valid. If expired or revoked, notify Higher Level Authority (Jenkins) and go back to step 1.

#### Bootstrapping to allow a Node/ app using AppRole
Hashicorp Vault also provides AppRole Auth backend, allowing you to specify an unique role-id, which will be associated with a secret-id upon creation.
Unclear: How to send token accessor to Node to allow lease renewal once secret-id expires?

1. Create AppRole by specifying URI and associating policy

    ```
    ./vault write auth/approle/role/production secret_id_ttl=5m token_ttl=5m token_max_ttl=5m secret_id_num_uses=2 policies=production
    ```
2. Do a read on this AppRole, passing Cubbyhole wrapper option -wrap-ttl
    ```
    ./vault read -wrap-ttl=20m auth/approle/role/production/role-id
    ```
3. This returns a cubbyhole token with time to live
4. Send token to app
5. Use ./vault unwrap [token] to get value of RoleId to use
6. ./vault auth [token]
6. Auth has ttl. When login, given a token, use vault token-renew <token> to renew auth lease

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

## Troubleshooting
Error:
_Error initializing Vault: Put https://127.0.0.1:8200/v1/sys/init: http: server gave HTTP response to HTTPS client_

Solution:

```
export VAULT_ADDR=http://127.0.0.1:8200
```
