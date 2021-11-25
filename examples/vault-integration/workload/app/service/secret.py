import hvac
import os

SVID_CERT = os.getenv('SVID_CERT', '/var/run/secrets/svid/svid.pem')
SVID_KEY = os.getenv('SVID_KEY', '/var/run/secrets/svid/svid-key.pem')
VAULT_ADDR = os.getenv('VAULT_ADDR', 'https://vault.vault.svc:8200')
VAULT_CERT_MOUNT = os.getenv('VAULT_CERT_NAME', 'cert')
VAULT_CERT_NAME = os.getenv('VAULT_CERT_NAME', 'spiffe')

from flask import send_file


def get():
    client = hvac.Client(
        url=VAULT_ADDR,
        verify='/etc/ssl/certs/ca-certificates.crt',
    )

    client.auth.cert.login(
        name=VAULT_CERT_NAME,
        cert_pem=SVID_CERT,
        key_pem=SVID_KEY,
        mount_point=VAULT_CERT_MOUNT,
        use_token=True
    )

    response = client.secrets.kv.v2.read_secret_version(path=f"workload")
    secret = {
        'secret': response['data']['data']
    }

    return secret, 200
