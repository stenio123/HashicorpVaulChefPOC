# Chef Server
Chef server installation instructions. It also copies the shared ssh key to allow Chef Workstation to communicate with Chef Server in order to download required certificates.

# Chef Nodes
This folder contains the definition of the Nodes that will be managed by Chef Server.

In a real world scenario, these nodes would be created dynamically based on a configuration file.

## Chef workstation
This node has chefdk installed and configured. It will be used to bootstrap the other nodes.
