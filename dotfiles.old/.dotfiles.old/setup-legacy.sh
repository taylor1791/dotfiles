function install_cron() {
  if ! crontab -l | grep -Fq "$1"; then
    echo "Installing cron: $1"
    crontab -l || true | { cat; echo "$1"; } | crontab -
  fi
}
