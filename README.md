[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# libvirt-sno-provisioner - Automate your Single Node OpenShift (SNO) provisioning on RHEL!

This project has been inspired by the [libvirt-ocp4-provisioner
](https://github.com/kubealex/libvirt-ocp4-provisioner) project, which did a great job creating the playbooks to provision existing infrastructure nodes on `libvirt` and preparing for cluster installation.

The primary focus of scripts in this repository is to automate Single Node OpenShift (SNO) cluster creation in RHEL using Terraform and Ansible.

## Prerequsites 

First of all, you need to install required collections to get started:

```bash
ansible-galaxy collection install -r requirements.yaml
```

The playbook is meant to run against local host/s, defined under **vm_host** group in your inventory, depending on how many clusters you want to configure at once.

Export environment variables:
```bash
# replace with actual file paths and values
export BASE_DOMAIN=mydomain.com
export CLUSTER_NAME=sno
export PULL_SECRET=$(cat ~/tmp/pull-secret)
export CERT_DIR=~/tmp/cert/mycert # directory with Let's Encrypt key, cert, and ca.crt
```


## Run playbook

```bash
ansible-playbook main-sno.yaml
```

You can quickly make it work by configuring the needed vars, but you can go straight with the defaults!


## Common vars

**vars/sno_vars.yaml**

```yaml
domain: "{{ lookup('env', 'BASE_DOMAIN') }}"
network_cidr: 192.168.1.0/24
cluster:
  version: stable
  name: "{{ lookup('env', 'CLUSTER_NAME') }}"
  ocp_user: admin
  ocp_pass: admin
  pullSecret: "{{ lookup('env', 'PULL_SECRET') }}"
cluster_nodes:
  host_list:
    sno:
      - ip: 192.168.1.17
        mac: 52:54:00:1f:35:50
  specs:
    sno:
      vcpu: 16
      mem: 56
      disk: 240
local_storage:
  enabled: true
  volume_size: 200
additional_nic:
  enabled: false
  network: ""
cert_dir: "{{ lookup('env', 'CERT_DIR') }}"
```

**local_storage** field can be used to provision an additional disk to the VM in order to provision volumes using, for instance, rook-ceph or local storage operator.

**additional_nic** allows the creation of an additional network interface on the node. It is possible to customize the libvirt network to attach to it.

In both cases, Pull Secret can be retrived easily at [https://cloud.redhat.com/openshift/install/pull-secret](https://cloud.redhat.com/openshift/install/pull-secret)

**HTPasswd** provider is created after the installation, you can use **ocp_user** and **ocp_pass** to login!

## Cleanup

To clean all resources, you can simply run the cleanup playbooks.

```bash
ansible-playbook -i inventory 99_cleanup_sno.yaml
```

**DISCLAIMER**
This project is for testing/lab only, it is not supported in any way by Red Hat nor endorsed.

