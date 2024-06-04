.PHONY: help
help:
	@echo "Usage for libvirt-ocp4-provisioner:"
	@echo "    setup                    to install required collections"
	@echo "    create-sno               to create the cluster using Single Node setup"
	@echo "    destroy                  to destroy the cluster"
.PHONY: setup
setup:
	@ansible-galaxy collection install -r requirements.yaml
.PHONY: create-sno
create-sno:
	@ansible-playbook main-sno.yaml -vv
.PHONY: destroy
destroy-sno:
	@ansible-playbook 99_cleanup_sno.yaml
