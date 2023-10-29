{ pkgs, writeShellApplication, ... }: writeShellApplication {
  name = "mirror";
  runtimeInputs = [ pkgs.wget ];

  text = ''
    wget \
      --wait=1 \
      --random-wait \
      --execute="robots = off" \
      --recursive \
      --page-requisites \
      --convert-links \
      --no-parent \
      --level 10 \
      "$@"
  '';
}
