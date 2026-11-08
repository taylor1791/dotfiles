{ pkgs, writeShellApplication, ... }: writeShellApplication {
  name = "fire";
  runtimeInputs = [ pkgs.taylor1791.claude-code pkgs.taylor1791.fireconnect ];

  text = ''
    # Claude Code, routed through Fireworks. `fireconnect claude on` normally
    # rewrites ~/.claude/settings.json in place; pointing it at a private
    # settings file instead leaves the real one alone, so `claude` stays on
    # Anthropic and `fire` is the only thing that talks to Fireworks.
    STATE_DIR="''${XDG_STATE_HOME:-''${HOME}/.local/state}/fire"
    SETTINGS="''${STATE_DIR}/settings.json"
    DATA_DIR="''${STATE_DIR}/fireconnect"

    function generate() {
      mkdir -p "''${DATA_DIR}"
      chmod 700 "''${STATE_DIR}" "''${DATA_DIR}"

      # fireconnect edits the file in place and needs valid JSON to start from.
      echo '{}' > "''${SETTINGS}"
      chmod 600 "''${SETTINGS}"

      fireconnect claude on \
        --settings-path "''${SETTINGS}" \
        --data-dir "''${DATA_DIR}" \
        "''${@}"
    }

    function help() {
      echo "USAGE: fire [refresh [...fireconnect-options]|...claude-options]"
      echo ""
      echo "    fire                 Run Claude Code against Fireworks."
      echo "    fire refresh         Regenerate the Fireworks settings."
      echo "    fire refresh --opus <id>"
      echo "                         Regenerate, pinning a model slot."
      echo ""
      echo "  Sign in once with \`fireconnect login\`. Settings live in"
      echo "  ''${STATE_DIR}; ~/.claude/settings.json is never touched."
      exit 1
    }

    if [[ "''${1-}" == "refresh" ]]; then
      shift
      generate "''${@}"
      exit 0
    fi

    if [[ "''${1-}" == "--help" ]]; then
      help
    fi

    # `{}` is the placeholder generate() writes before handing off; treat a
    # leftover one as "never successfully generated".
    if ! [[ -s "''${SETTINGS}" ]] || [[ "$(< "''${SETTINGS}")" == "{}" ]]; then
      echo "fire: no Fireworks settings yet, generating..." >&2
      generate
    fi

    exec claude --settings "''${SETTINGS}" "''${@}"
  '';
}
