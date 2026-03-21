# SNO Provisioning Flow

This repository provisions a single OpenShift SNO VM in a home lab using Ansible and Terraform.

## Execution flow

1. `playbooks/00_prereqs.yaml`
   - Validates runtime env vars and host compatibility.
2. `playbooks/10_workspace.yaml`
   - Creates working directories and copies Terraform assets.
3. `playbooks/20_host_tools.yaml`
   - Installs virtualization dependencies, Terraform, and libvirt resources.
4. `playbooks/30_sno_install.yaml`
   - Downloads OpenShift tooling/media, generates ignition, provisions VM, waits for install.
5. Optional post-install stages
   - `playbooks/40_idp.yaml`
   - `playbooks/50_storage.yaml`
   - `playbooks/60_registry.yaml`
   - `playbooks/70_certs.yaml`
6. Cleanup
   - `playbooks/99_cleanup.yaml`

## Configuration sources

- `vars/sno_vars.yaml` contains cluster parameters and env lookups.
- `config/.env.local` (ignored by git) provides all local runtime variables, including secrets.

## Key directories

- `playbooks/` normalized playbook names.
- `templates/` generated manifests/scripts.
- `terraform/` libvirt network/pool/VM definitions.
- `group_vars/vm_host/` shared download and tooling variables.
