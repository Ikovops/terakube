terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "2.21.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

provider "linode" {
  # Configuration options
}

provider "local" {
  # Configuration options
}

resource "linode_vpc" "vpc" {
  label = "terakube-vpc"
	description = "Terakube VPC for testing purpposes."
	region = local.region
}

resource "linode_vpc_subnet" "subnet" {
  vpc_id = linode_vpc.vpc.id
	label = "terakube-sub"
	ipv4 = "10.0.244.0/24"
}

resource "linode_instance_disk" "boot" {
	count = local.instance_number
	linode_id = linode_instance.instances[count.index].id
  label = "custom-boot"
	size = local.disk_size
	image = "linode/debian12"
	authorized_keys = local.auth_keys
	root_pass = local.root_pwd
}

resource "linode_instance_config" "config" {
	count = local.instance_number
	linode_id = linode_instance.instances[count.index].id
	label = "Custom"
	kernel = "linode/grub2"

	device {
	  device_name = "sda"
		disk_id = linode_instance_disk.boot[count.index].id
	}

	interface {
	  purpose = "public"
	}

	interface {
	  purpose = "vpc"
		subnet_id = linode_vpc_subnet.subnet.id
		primary = true
		ipv4 {
		  vpc = "10.0.244.1${count.index}0"
			# automatic IPv4 public IP on node
			nat_1_1 = "any"
		}
	}

	booted = true
}

resource "linode_instance" "instances" {
	count = local.instance_number
	label = "instance-${count.index}"
	region = local.region
	type = local.instance_type
	tags = ["terakube"]

resource "local_file" "ansible-inventory" {
  filename = "./ansible/inventory.yaml"
	content = <<-EOF
control_plane:
  hosts:
    main_node:
      ansible_host: ${linode_instance.instances[0].ip_address}
      hostname: control-plane

workers:
  hosts:
    worker_one:
      ansible_host: ${linode_instance.instances[1].ip_address}
      hostname: worker-one
    worker_two:
      ansible_host: ${linode_instance.instances[2].ip_address}
      hostname: worker-two
	EOF
}

