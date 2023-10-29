{ pkgs, writeShellApplication, ... }: writeShellApplication {
  name = "color";
  runtimeInputs = [ pkgs.gawk ];

  text = ''
    # Original: https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
    # This script includes modifications for dim and italic. It does not include
    # ANSI escape codes above 3. See https://en.wikipedia.org/wiki/ANSI_escape_code
    function colors() {
      T='gYw'   # The test text
      echo -e "\n                   40m     41m     42m     43m     44m     45m     46m     47m";
      for FGs in \
        '      m' '     1m' '     2m' '     3m' \
        '    30m' '  1;30m' '  2;30m' '  3;30m' \
        '    31m' '  1;31m' '  2;31m' '  3;31m' \
        '    32m' '  1;32m' '  2;32m' '  3;32m' \
        '    33m' '  1;33m' '  2;33m' '  3;33m' \
        '    34m' '  1;34m' '  2;34m' '  3;34m' \
        '    35m' '  1;35m' '  2;35m' '  3;35m' \
        '    36m' '  1;36m' '  2;36m' '  3;36m' \
        '    37m' '  1;37m' '  2;37m' '  3;37m'; do
        FG=''${FGs// /}
        echo -en " $FGs \033[$FG  $T  \033[0m"
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
          echo -en " \033[$FG\033[$BG  $T  \033[0m\033[$BG\033[0m";
        done
        echo;
      done
    }

    # Taken from https://unix.stackexchange.com/questions/404414/print-true-color-24-bit-test-pattern#answer-404415
    function truecolor() {
      awk -v term_cols="''${width:-''$(tput cols || echo 80)}" 'BEGIN{
          s="/\\";
          for (colnum = 0; colnum<term_cols; colnum++) {
              r = 255-(colnum*255/term_cols);
              g = (colnum*510/term_cols);
              b = (colnum*255/term_cols);
              if (g>255) g = 510-g;
              printf "\033[48;2;%d;%d;%dm", r,g,b;
              printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
              printf "%s\033[0m", substr(s,colnum%2+1,1);
          }
          printf "\n";
      }'
    }

    colors
    echo
    truecolor
  '';
}
