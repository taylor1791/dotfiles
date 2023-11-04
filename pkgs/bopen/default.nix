{ pkgs, writeShellApplication, ... }: writeShellApplication {
  name = "bopen";
  runtimeInputs = [ pkgs.gnused pkgs.taylor1791.warn ];

  text = ''
    CONFIG_DIR="$HOME/.local/state/bopen"

    function init() {
      if ! [[ -d "''${CONFIG_DIR}" ]]; then
        mkdir -p "''${CONFIG_DIR}"
      fi

      if ! [[ -f "''${1}" ]]; then
        touch "''${1}"
      fi
    }

    function cmd_add() {
      local file="''${1}"
      shift

      init "''${file}"

      while [[ "''${#}" -gt "0" ]]; do
        echo "''${1}" >> "''${file}"
        shift
      done
    }

    function cmd_edit() {
      init "''${1}"

      "''${EDITOR-vi}" "''${1}"
    }

    function cmd_open() {
      init "''${1}"

      # Open all the things!
      declare line="";
      while read -r line; do
        _open "''${line}"
      done < "''${1}"

      # Open the trickles
      shift
      while [[ "''${#}" -gt "0" ]]; do
        init "''${1}"

        line="$(head -n 1 "''${1}")"
        if [[ "''${line}" != "" ]]; then
          sed -i '1d' "''${1}"
          echo "''${line}" >> "''${1}"
          _open "''${line}"
        fi
        shift
      done
    }

    function cmd_pop() {
      init "''${1}"

      tail -n -1 "''${1}"
      sed -i '$d' "''${1}"
    }

    function _open() {
      if command -v open > /dev/null; then
        open "''${@}"
      elif command -v xdg-open > /dev/null; then
        xdg-open "''${@}"
      fi
    }

    function die() {
      if [[ "''${1}" != "" ]]; then
        warn "ERROR: ''${1}"
        echo ""
      fi

      echo "USAGE: bopen {add [...items]"
      echo "             |edit"
      echo "             |open [(-t|--trickle) <name>]"
      echo "             |pop}"
      echo "             [(-n|--name) <name>]"
      echo ""
      echo "  Commands:"
      echo "    add   Adds an item to the list."
      echo "    edit  Edit the list contents."
      echo "    open  Runs \`xdg-open\` on all items."
      echo "    pop   Remove the last list item."
      echo ""
      echo "  Options:"
      echo "    --name     The list opperations are performed on."
      echo "    --trickle  Also open one item from this list. Multiple allowed."
      exit 1
    }

    NAME="''${CONFIG_DIR}/default"
    POSITIONAL=()
    TRICKLE=()
    while [[ $# -gt 0 ]]; do
      case $1 in
        -h|--help)
          die "You want help? I got help!"
        ;;

        -n|--name)
          NAME="''${CONFIG_DIR}/''${2}"
          shift
          shift
        ;;

        -t|--trickle)
          TRICKLE+=("''${CONFIG_DIR}/''${2}")
          shift
          shift
        ;;

        *)
          POSITIONAL+=("''${1}")
          shift
        ;;
      esac
    done
    set -- "''${POSITIONAL[@]}"

    if [[ "''${#POSITIONAL[@]}" == "0" ]]; then
      die "Missing command."
    fi

    # If command is specified, use it. Otherwise, default to open.
    if [[
      "''${POSITIONAL[0]}" == "add" || \
      "''${POSITIONAL[0]}" == "edit" || \
      "''${POSITIONAL[0]}" == "open" || \
      "''${POSITIONAL[0]}" == "pop" ]]; then
      COMMAND="''${POSITIONAL[0]}"
      POSITIONAL=("''${POSITIONAL[@]:1}")
    else
      COMMAND="open"
    fi

    # Begin validation
    if [[ "''${COMMAND}" != "add" && "''${#POSITIONAL[@]}" != "0" ]]; then
      die "Unsupported argument, ''${POSITIONAL[0]}, on ''${COMMAND} command."
    fi

    if [[ "''${COMMAND}" != "open" && "''${#TRICKLE[@]}" != "0" ]]; then
      die "Unsupported option, --trickle, on ''${COMMAND} command "
    fi

    if [[ "''${COMMAND}" == "add" ]]; then
      cmd_add "''${NAME}" "''${POSITIONAL[@]}"
    elif [[ "''${COMMAND}" == "edit" ]]; then
      cmd_edit "''${NAME}"
    elif [[ "''${COMMAND}" == "open" ]]; then
      cmd_open "''${NAME}" "''${TRICKLE[@]}"
    elif [[ "''${COMMAND}" == "pop" ]]; then
      cmd_pop "''${NAME}"
    fi
  '';
}
