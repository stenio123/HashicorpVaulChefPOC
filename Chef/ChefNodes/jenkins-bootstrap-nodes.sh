# This represents the bootstrapping process that should be done by Jenkins or other actor.

# Creates nodes
ruby create-nodes.rb
# Starts VMs
vagrant up
# Bootstraps Nodes to chef
# (Assumes that install-wk has been executed in whoever is issuing this command)
loop [nodes]{
  curl \
    -H "X-Vault-Token:7069bec9-e020-041c-5cbc-e0755b7e3f5e" \
    -X GET \
    http://192.168.0.43:8200/v1/secret?list=true
  knife bootstrap vagrant@[node.ip] -i ~/.ssh/id_rsa \
    --sudo --use-sudo-password \
    --environment [node.environment] \
    --json-attributes {"cubbyhole-token": [token]}
}
