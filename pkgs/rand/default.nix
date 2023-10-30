{ pkgs, writeShellApplication, ... }: writeShellApplication {
  name = "rand";
  runtimeInputs = [ pkgs.coreutils pkgs.libressl pkgs.xxd];

  text = ''
    function roll() {
      awk "BEGIN { \"date +%N\" | getline seed; srand(seed); print 1 + int($1 * rand()); }"
    }

    BITS="$(printf "%8s" "0b$(< /dev/urandom head -c 1 | xxd -b | awk '{ print substr($2, 0, 4); }')")"
    COIN="$(shuf --repeat --head-count 1 --echo '   heads' '   tails')"
    D4="$(printf "%8s" "$(roll 4)+$(roll 4)+$(roll 4)")"
    D6="$(printf "%8s" "$(roll 6)+$(roll 6)+$(roll 6)")"
    D8="$(printf "%8s" "$(roll 8)+$(roll 8)+$(roll 8)")"
    D10="$(printf "%9s" "$(roll 10)+$(roll 10)+$(roll 10)")"
    D12="$(printf "%9s" "$(roll 12)+$(roll 12)+$(roll 12)")"
    D20="$(printf "%6s" "$(roll 20)+$(roll 20)")"
    D100="$(printf "%8s" "$(roll 100)+$(roll 100)")"

    echo "    bits    coin     3d4     3d6     3d8     3d10     3d12  2d20   2d100"
    echo "$BITS$COIN$D4$D6$D8$D10$D12$D20$D100"
    echo ""
    openssl rand 160 -hex | fold -w 80
    echo ""
    openssl rand 144 -base64
  '';
}
