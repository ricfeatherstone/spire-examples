server {
  bind_address     = "0.0.0.0"
  bind_port        = "8081"
  socket_path      = "/tmp/spire-server/private/api.sock"
  data_dir         = "/run/spire/data"
  log_level        = "DEBUG"
  trust_domain     = "example.org"
  default_svid_ttl = "1h"
  ca_key_type      = "rsa-2048"
}

plugins {
  DataStore "sql" {
    plugin_data {
      database_type     = "sqlite3"
      connection_string = "/run/spire/data/datastore.sqlite3"
    }
  }

  KeyManager "disk" {
    plugin_data {
      keys_path = "/run/spire/data/keys.json"
    }
  }

  NodeAttestor "k8s_psat" {
    plugin_data {
      clusters = {
        "demo-cluster" = {
          service_account_allow_list = [
            "spire:spire-agent",
          ]
          audience                   = [
            "spire",
          ]
        }
      }
    }
  }

  Notifier "k8sbundle" {
    plugin_data {
    }
  }

  UpstreamAuthority "vault" {
    plugin_data {
      vault_addr           = "https://vault.vault.svc:8200"
      pki_mount_point      = "spiffe"
      insecure_skip_verify = true
      k8s_auth {
        k8s_auth_role_name = "spire-server"
        token_path         = "/var/run/secrets/tokens/vault-token"
      }
    }
  }
}

health_checks {
  listener_enabled = true
  bind_address     = "0.0.0.0"
  bind_port        = "8080"
  live_path        = "/live"
  ready_path       = "/ready"
}
