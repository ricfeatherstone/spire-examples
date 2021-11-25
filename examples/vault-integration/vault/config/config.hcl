disable_mlock = true
ui            = true

listener "tcp" {
  address         = "[::]:8200"
  cluster_address = "[::]:8201"
  tls_cert_file   = "/var/run/secrets/tls/tls.crt"
  tls_key_file    = "/var/run/secrets/tls/tls.key"
}

storage "inmem" {
}
