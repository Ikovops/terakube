terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "2.21.1"
    }
  }
}

provider "linode" {
  # Configuration options
}

resource "linode_vpc" "vpc" {
  label = "terakube-vpc"
	region = "fr-par"
	description = "Terakube VPC for testing purpposes."
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
}
