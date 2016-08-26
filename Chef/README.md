# Chef Server
Chef server installation instructions. It also copies the shared ssh key to allow Chef Workstation to communicate with Chef Server in order to download required certificates.

# Chef Nodes
This folder contains the definition of the Nodes that will be managed by Chef Server.

The files simulate a real world scenario, where these nodes are created dynamically based on a configuration file- in this case _node-definition.json_.

_jenkins-bootstrap-nodes.sh_ contains the sequence of commands to be executed by Jenkins or similar actor to bootstrap the Nodes and allow them to communicate with Hashicorp Vault.

## Chef workstation
This node has chefdk installed and configured. It will be used to bootstrap the other nodes.
