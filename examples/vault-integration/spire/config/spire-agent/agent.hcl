agent {
  data_dir          = "/run/spire/data"
  log_level         = "DEBUG"
  server_address    = "spire-server"
  server_port       = "8081"
  socket_path       = "/run/spire/sockets/agent.sock"
  trust_bundle_path = "/run/spire/bundle/bundle.crt"
  trust_domain      = "example.org"
}

plugins {
  KeyManager "disk" {
    plugin_data {
      directory = "/run/spire/data/agent"
    }
  }

  NodeAttestor "k8s_psat" {
    plugin_data {
      cluster    = "demo-cluster"
      token_path = "/run/spire/tokens/spire-token"
    }
  }

  WorkloadAttestor "k8s" {
    plugin_data {
      skip_kubelet_verification = true
    }
  }

  WorkloadAttestor "unix" {
    plugin_data {
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
