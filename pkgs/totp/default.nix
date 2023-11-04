{ pkgs, writeShellApplication, ... }: writeShellApplication {
  name = "totp";
  runtimeInputs = [ pkgs.oath-toolkit pkgs.rage ];

  text = ''
    # Make patterns without matches expand to the a null string. Not the glob.
    shopt -s nullglob

    CONFIG_DIR="''${HOME}/.local/state/totp"

    function add() {
      if [[ "''${1}" == "" ]]; then
        echo "Missing profile-name."
        echo ""
        help
      fi

      if [[ "''${2}" == "" ]]; then
        echo "Missing private-key."
        echo ""
        help
      fi

      if [[ -e "''${CONFIG_DIR}/''${1}" ]]; then
        die "Profile ''${1} already exists. Use a new name or delete the existing profile."
      fi

      set_key_file
      mkdir -p "''${CONFIG_DIR}"
      echo "''${2}" | rage -r "$(<"''${KEY_FILE}")" > "''${CONFIG_DIR}/''${1}"
    }

    function get() {
      if [[ "''${1}" == "" ]]; then
        echo "Missing profile-name."
        echo ""
        help
      fi

      declare totp_private_key_file="''${CONFIG_DIR}/''${1}"
      if ! [[ -e "''${totp_private_key_file}" ]]; then
        die "Unknown profile: ''${1}"
      fi

      set_key_file
      declare ssh_private_key_file
      ssh_private_key_file="''${HOME}/.ssh/$(basename -s .pub "''${KEY_FILE}")"
      if ! [[ -e "''${ssh_private_key_file}" ]]; then
        die "Missing private key: ''${ssh_private_key_file}"
      fi

      # Right now, this will ask for the passphrase on the ssh private key. After
      # the first plugin, it will support decrypting keyfiles using ssh-agent.
      totp_private_key="$(rage -d -i "''${ssh_private_key_file}" "''${totp_private_key_file}")"

      oathtool --totp -b "''${totp_private_key}"
    }

    function set_key_file() {
      declare -a public_keys=("''${HOME}"/.ssh/*.pub)

      if [[ "''${#public_keys[@]}" != "1" ]]; then
        die "totp expected one public key in ~/.ssh. Either hack it or make an MR."
      fi

      KEY_FILE="''${public_keys[0]}"
    }

    function help() {
      echo "USAGE: totp [add|get]"
      echo ""
      echo "    add {name} {key}   Add a new TOTP generator name {name}."
      echo "    get {name}         Report the current TOTP for profile {name}."
      exit 1
    }

    function die() {
      echo "''${1-Unknown error}"
      exit 1
    }

    if [[ "''${1-}" == "add" ]]; then
      add "''${2-}" "''${3-}"
    elif [[ "''${1-}" == "get" ]]; then
      get "''${2-}"
    else
      help
    fi
  '';
}
