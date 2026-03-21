[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# libvirt-sno-provisioner

Automates deployment of a **Single Node OpenShift (SNO)** cluster on a local `libvirt` host for home-lab/testing use.

## What this project does

- Provisions one VM on `libvirt` and installs OpenShift SNO (single node acts as control-plane and worker).
- Uses Ansible + Terraform to prepare host tools, libvirt resources, and VM artifacts.
- Optionally configures post-install components:
  - HTPasswd IDP
  - LVM Storage operator
  - Internal image registry PVC backend
  - Custom ingress/API certificates

For architecture and file mapping, see [`docs/architecture.md`](docs/architecture.md).

## Prerequisites

- RHEL host with virtualization support
- Ansible installed
- Access to OpenShift pull secret
- Required Ansible collections:

```bash
ansible-galaxy collection install -r requirements.yaml
```

Inventory defaults to local host:

```ini
[vm_host]
localhost ansible_connection=local
```

## Configuration model

Configuration is driven from:

- `config/.env.local` (ignored, local runtime values including secrets)
- `vars/sno_vars.yaml` (Ansible variables and env lookups)

Create local env file from example:

```bash
cp config/.env.example config/.env.local
```

Edit `config/.env.local` with real values:

```bash
export BASE_DOMAIN=example.lab
export CLUSTER_NAME=sno
export OCP_USER=admin
export OCP_PASS='replace-me'
export PULL_SECRET='...'
export CERT_DIR=~/.acme.sh/example.lab_ecc
```

Load `.env.local` before running playbooks:

```bash
source scripts/load-env.sh
```

## Run SNO install

```bash
ansible-playbook -i inventory main-sno.yaml
```

The main entrypoint imports normalized playbook names in `playbooks/`.

## Optional feature flags

All enabled by default unless overridden in env:

- `ENABLE_IDP=true|false`
- `ENABLE_STORAGE=true|false`
- `ENABLE_IMAGE_REGISTRY=true|false`
- `ENABLE_CERTS=true|false`

## Cleanup

```bash
ansible-playbook -i inventory playbooks/99_cleanup.yaml
```

## Notes

- This project is intended for home-lab/testing usage.
- Do not commit sensitive files (`config/.env.local`, pull secrets, generated auth artifacts).

