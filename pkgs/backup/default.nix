{ pkgs, writeShellApplication, ... }: let
  excludes = pkgs.writeText "borg.excludes" ''
    */.DS_Store
    */.Trash
    */._*
    */.cache
    */.gradle
    */.npm
    */Caches
    */cache
    */node_modules
    */tmp

    */podman/machine/qemu/
    */Library/Containers/com.docker.docker
    */Library/Application Support/Google/Chrome
  '';
in writeShellApplication {
  name = "backup";
  runtimeInputs = [ pkgs.taylor1791.borgbackup pkgs.taylor1791.warn ];

  text = ''
    FLAGS=()

    function main() {
      if [[ -z "''${HOSTNAME}" ]]; then
        echo "HOSTNAME not set"
        exit 1
      fi

      if [[ -z "''${BORG_REPO}" ]]; then
        echo "BORG_REPO not set"
        exit 1
      fi

      if ! borg check 2> /dev/null; then
        echo "Borg repo not initialized. Initializing..."
        borg init --encryption=none
      fi

      borg create \
        --stats --progress \
        "''${FLAGS[@]}" \
        --exclude-from ${excludes} \
        '::{user}-{now}' ~
    }

    while [[ $# -gt 0 ]]; do
      case "$1" in
        --dry-run)
          FLAGS+=(--dry-run)
          FLAGS+=(--list)
          shift
        ;;

        *)
          echo "Unknown option: $1"
          exit 1
        ;;
      esac
    done

    main
  '';
}
