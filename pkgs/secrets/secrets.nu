#!/usr/bin/env nu

def get-hostname [] {
  hostname | str trim
}

def "main pull" [hostname?: string] {
  let host = ($hostname | default (get-hostname))
  let vault_path = $"kv/*@idagalaxy.com/taylor1791/hosts/($host)"

  # List secrets at path
  let secrets = (
    with-env { VAULT_ADDR: "https://vault.idagalaxy.com" } {
      vault kv list -format=json $vault_path
    } | from json
  )

  for secret in $secrets {
    let dest = $"/run/keys/($secret)"

    if not ($dest | path exists) {
      let value = (
        with-env { VAULT_ADDR: "https://vault.idagalaxy.com" } {
          vault kv get -field=value $"($vault_path)/($secret)"
        }
      )
      $value | sudo tee $dest | ignore
    }
  }
}

def main [] {
  print "secrets - Vault secrets manager"
  print ""
  print "USAGE:"
  print "  secrets pull [hostname]"
  print ""
  print "COMMANDS:"
  print "  pull    Sync secrets from Vault to /run/keys/"
}
