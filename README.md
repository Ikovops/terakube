# Terakube

## Goal of the project

- Learn Terraform.
- Learn Ansible.
- Deploy a Kubernetes cluster against Linode cloud provider.

## TODO

- [ ] `instance-0` node should initialize the kube cluster.
- [ ] The node must install Flannel networking component.
- [ ] The nodes should join the kube cluster automatically.
- [ ] Decouple files to adapt from different cloud providers.

### Variables

- instance_number = 1 # Increase this number if you wish more computing power.
- disk_size = 10\*1024 # MG to GB, increase first operand to increase disk size
- region = "" # One region that is provided by your provider
- instance_type = "" # Instance code from your provider
- auth_keys = [] # SSH public key to add in the known_hosts node's file
- root_pwd = "" # Explicit.

### Ansible

Apply terraform file :

```bash
terraform apply
```

Provision deployed nodes :

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i 'xxx.xxx.xxx.xxx,[...]' --private-key ${PRIVATE_KEY} ./ansible/playbook.yaml
```

### Main provider

[Linode](https://cloud.linode.com/)
