title Secrets Management

Jenkins->Hashicorp Vault: Initialize Vault
Jenkins->Hashicorp Vault: Create Policies
Jenkins->Hashicorp Vault: Create Token for Policy
note right of Jenkins: Policy comes from\nNode definition
Hashicorp Vault->Jenkins: Returns single-use wrapper token
Jenkins->Chef Node: Bootstraps Node, passing wrapped token
Chef Node->Hashicorp Vault: Unwraps token, gets token and access lease
Chef Node->Chef Node: Stores token in memory?
Chef Node->Hashicorp Vault: When needed, renews token
Chef Node->Hashicorp Vault: Gets secrets
