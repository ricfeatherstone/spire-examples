# Spire Vault Integration Examples

Demonstrating

* Vault as an Upstream Authority.
* Authenticating to Vault using an X509 SVID.


1. Deploy Vault - `make deploy-vault`
2. Configure Vault - `make configure-vault`
3. Deploy Spire - `make deploy-spire`
4. Configure Spire - `make configure-spire`
5. Build and Deploy Workload
    * Kind - `make deploy-workload-kind`
6. View Workloads X509 SVID - `make view-workload-x509-svid`
7. View Workloads Secrets from Vault - `make view-workloads-secrets`
