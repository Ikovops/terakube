# Terakube

## Goal of the project

- Use Terraform.
- Use and dive into Ansible.
- Deploy a from-scratch Kubernetes cluster against multiple cloud providers.

## TODO

- [x] `instance-0` node should initialize the kube cluster.
- [x] The node must install Calico networking component.
- [x] The nodes should join the kube cluster automatically.
- [ ] The cluter should have an LB to expose Nginx as first app.
- [ ] Decouple files to adapt from different cloud providers.

### Variables

```
instance_number = 1 # Increase this number if you wish more computing power.
disk_size = 10\*1024 # MG to GB, increase first operand to increase disk size
region = "" # One region that is provided by your provider
instance_type = "" # Instance code from your provider
auth_keys = [] # SSH public key to add in the known_hosts node's file
root_pwd = "" # Explicit.
```

### Terraform

Plan & Apply terraform file :

```bash
terraform plan
```

```bash
terraform apply
```

### Ansible

Provision deployed nodes :

```bash
ansible-galaxy install -r ./ansible/requirements.yaml # Do it once
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./ansible/inventory.yaml --private-key ${PRIVATE_KEY} ./ansible/playbook.yaml
```

### Main provider

[Linode](https://cloud.linode.com/)
