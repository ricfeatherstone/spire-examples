
cyan := $(shell which tput > /dev/null && tput setaf 6 2>/dev/null || echo "")
reset := $(shell which tput > /dev/null && tput sgr0 2>/dev/null || echo "")
bold  := $(shell which tput > /dev/null && tput bold 2>/dev/null || echo "")

help:
	@echo "$(bold)Usage:$(reset) make $(cyan)<target>$(reset)"
	@echo
	@echo "$(cyan)generate-certs$(reset)          - generate tls material for vault"
	@echo "$(cyan)cleanup-certs$(reset)           - delete tls material for vault"
	@echo "$(cyan)deploy-vault$(reset)            - deploy vault"
	@echo "$(cyan)configure-vault$(reset)         - configure vault"
	@echo "$(cyan)deploy-spire$(reset)            - deploy spire; csi-driver, server, agent"
	@echo "$(cyan)configure-spire$(reset)         - create registration entries; agent, workload"
	@echo "$(cyan)deploy-workload-kind$(reset)    - build workload image, load into kind cluster and deploy"
	@echo "$(cyan)view-workload-x509-svid$(reset) - view the X509 SVID the workload uses for ssl"
	@echo "$(cyan)view-workload-secrets$(reset)   - call the workload to retrieve the secrets loaded from vault"

generate-certs: cleanup-certs
	cd vault && ./generate-certs.sh

cleanup-certs:
	-cd vault && ./cleanup-certs.sh

deploy-vault: generate-certs
	kubectl create ns vault
	kubectl apply -k vault/config

configure-vault:
	cd vault && ./configure-vault.sh

deploy-spire:
	kubectl create ns spire
	kubectl apply -k spire/config

configure-spire:
	./spire/register-entries.sh

deploy-workload-kind:
	cd workload && docker build -t workload:latest .
	kind load docker-image workload:latest
	kubectl apply -k workload/config

view-workload-x509-svid:
	./workload/view-workload-x509-svid.sh

view-workload-secrets:
	./workload/view-workload-secrets.sh
