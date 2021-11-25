
cyan := $(shell which tput > /dev/null && tput setaf 6 2>/dev/null || echo "")
reset := $(shell which tput > /dev/null && tput sgr0 2>/dev/null || echo "")
bold  := $(shell which tput > /dev/null && tput bold 2>/dev/null || echo "")

help:
	@echo "$(bold)Usage:$(reset) make $(cyan)<target>$(reset)"
	@echo
	@echo "$(cyan)generate-certs$(reset)       - generate tls material for vault"
	@echo "$(cyan)cleanup-certs$(reset)        - delete tls material for vault"
	@echo "$(cyan)deploy-vault$(reset)         - deploy vault"
	@echo "$(cyan)configure-vault$(reset)      - configure vault"
	@echo "$(cyan)deploy-spire$(reset)         - deploy spire; csi-driver, server, agent"
	@echo "$(cyan)configure-spire$(reset)      - create registration entries; agent, workload"
	@echo "$(cyan)deploy-workload-kind$(reset) - build workload image, load into kind cluster and deploy"
	@echo "$(cyan)call-workload$(reset)        - call the workload to retrieve the secrets loaded from vault"
	@echo "$(cyan)view-workload-cert$(reset)   - view the X509 SVID the workload uses for ssl"

generate-certs: cleanup-certs
	cd vault && ./generate-certs.sh

cleanup-certs:
	-cd vault && ./cleanup-certs.sh

