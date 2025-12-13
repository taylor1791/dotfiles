#!/usr/bin/env nu

# unotify - Terminal Notification System
# A file-based notification system for terminal users.

# Get the base directory for unotify data
def get-base-dir [] {
  let xdg = ($env | get -o XDG_DATA_HOME | default "")
  if $xdg == "" {
    $env.HOME | path join ".local/share/unotify"
  } else {
    $xdg | path join "unotify"
  }
}

# Ensure all required directories exist
def ensure-dirs [] {
  let base = (get-base-dir)
  let dirs = [
    ($base | path join "new/persist")
    ($base | path join "new/once")
    ($base | path join "viewed/persist")
    ($base | path join "archive")
    ($base | path join "tmp")
  ]
  for dir in $dirs {
    mkdir $dir
  }
}

# Generate a 6-character base32 ID (30 bits of entropy)
def generate-id [] {
  # Use random bytes and encode as base32-like (lowercase alphanumeric without confusing chars)
  let chars = "abcdefghjkmnpqrstuvwxyz23456789"  # 32 chars, no i/l/o/0/1
  let id = (0..5 | each { |_|
    let idx = (random int 0..31)
    $chars | str substring $idx..($idx + 1)
  } | str join)
  $id
}

# Format relative time (e.g., "2m", "1h", "3d")
def format-relative-time [timestamp: string] {
  let now = (date now)
  let then = ($timestamp | into datetime)
  let diff = ($now - $then)

  let minutes = ($diff / 1min | math floor)
  let hours = ($diff / 1hr | math floor)
  let days = ($diff / 1day | math floor)

  if $days >= 1 {
    $"($days)d"
  } else if $hours >= 1 {
    $"($hours)h"
  } else if $minutes >= 1 {
    $"($minutes)m"
  } else {
    "now"
  }
}

# ANSI color codes
def ansi-yellow-bold [] { "\e[1;33m" }
def ansi-cyan-dim [] { "\e[2;36m" }
def ansi-dim [] { "\e[2m" }
def ansi-reset [] { "\e[0m" }

# Format a notification for display
def format-notification [notif: record] {
  let indicator = if $notif.persist { $"(ansi-yellow-bold)●(ansi-reset)" } else { $"(ansi-cyan-dim)○(ansi-reset)" }
  let source = ($notif | get -o source | default "unotify")
  let time = (format-relative-time $notif.timestamp)
  let msg = $notif.message

  $"($indicator) ($source)[(ansi-dim)($time)(ansi-reset)]: ($msg)"
}

# Read all notifications from a directory
def read-notifications [dir: string] {
  if not ($dir | path exists) {
    return []
  }

  let files = (ls $dir | where type == "file" | get name)

  $files | each { |file|
    try {
      let content = (open $file)
      $content | insert _file $file
    } catch {
      # Skip corrupted files
      null
    }
  } | compact
}

# Atomic write: write to tmp then move
def atomic-write [dest: string, data: record] {
  let base = (get-base-dir)
  let tmp_dir = ($base | path join "tmp")
  let tmp_file = ($tmp_dir | path join $"(generate-id).tmp")

  mkdir $tmp_dir
  $data | to nuon | save -f $tmp_file
  mv $tmp_file $dest
}

# Atomic move with error handling
def atomic-move [src: string, dest_dir: string] {
  mkdir $dest_dir
  let dest = ($dest_dir | path join ($src | path basename))
  try {
    mv $src $dest
    true
  } catch {
    # File may have been moved by another process
    false
  }
}

# Add a notification
def "main add" [
  message: string        # The notification message
  --source (-s): string  # Source of the notification
  --key (-k): string     # Deduplication key
  --persist (-p)         # Make notification persistent (requires manual clear)
] {
  ensure-dirs

  let base = (get-base-dir)
  let id = (generate-id)
  let timestamp = (date now | format date "%Y-%m-%dT%H:%M:%S%z")

  let notif = {
    id: $id
    key: $key
    message: $message
    timestamp: $timestamp
    source: $source
    persist: $persist
  }

  let subdir = if $persist { "persist" } else { "once" }
  let dest = ($base | path join "new" $subdir $"($id).nuon")

  atomic-write $dest $notif
}

# Show pending notifications
def "main show" [] {
  ensure-dirs

  let base = (get-base-dir)

  # Read from all pending locations
  let new_persist = (read-notifications ($base | path join "new/persist"))
  let new_once = (read-notifications ($base | path join "new/once"))
  let viewed_persist = (read-notifications ($base | path join "viewed/persist"))

  # Combine all notifications
  let all_notifs = ($new_persist | append $new_once | append $viewed_persist)

  if ($all_notifs | is-empty) {
    return
  }

  # Sort by timestamp (oldest first)
  let sorted = ($all_notifs | sort-by timestamp)

  # Deduplicate by key (keep oldest)
  let deduped = ($sorted | reduce -f [] { |notif, acc|
    let key = ($notif | get -o key)
    if $key == null {
      # No key, always include
      $acc | append $notif
    } else {
      # Check if key already exists
      let exists = ($acc | any { |n| ($n | get -o key) == $key })
      if $exists {
        $acc
      } else {
        $acc | append $notif
      }
    }
  })

  # Display notifications
  for notif in $deduped {
    print (format-notification $notif)
  }

  # Move files to appropriate destinations
  let archive_dir = ($base | path join "archive")
  let viewed_dir = ($base | path join "viewed/persist")

  # Move all once notifications to archive
  for notif in $new_once {
    atomic-move $notif._file $archive_dir
  }

  # Move new persist to viewed
  for notif in $new_persist {
    atomic-move $notif._file $viewed_dir
  }

  # viewed_persist stays where it is (will show again next time)
}

# Clear viewed persist notifications
def "main clear" [] {
  ensure-dirs

  let base = (get-base-dir)
  let viewed_dir = ($base | path join "viewed/persist")
  let archive_dir = ($base | path join "archive")

  if not ($viewed_dir | path exists) {
    return
  }

  let files = (ls $viewed_dir | where type == "file" | get name)

  for file in $files {
    atomic-move $file $archive_dir
  }
}

# Output shell hook code
def "main hook" [
  shell: string  # Shell to generate hook for (bash)
] {
  if $shell == "bash" {
    print '__unotify_prompt_command() {
  if command -v unotify > /dev/null && [ -t 1 ]; then
    unotify show 2>/dev/null
  fi
}
PROMPT_COMMAND="__unotify_prompt_command${PROMPT_COMMAND:+;$PROMPT_COMMAND}"'
  } else {
    print -e $"Unknown shell: ($shell). Supported: bash"
    exit 1
  }
}

# Show help
def "main help" [] {
  print "unotify - Terminal Notification System"
  print ""
  print "USAGE:"
  print "  unotify add <message> [-s <source>] [-k <key>] [-p]"
  print "  unotify show"
  print "  unotify clear"
  print "  unotify hook <shell>"
  print ""
  print "COMMANDS:"
  print "  add      Add a notification (once by default)"
  print "  show     Display pending notifications"
  print "  clear    Clear all viewed persist notifications"
  print "  hook     Output shell hook code"
  print ""
  print "FLAGS:"
  print "  -s, --source   Source of the notification"
  print "  -k, --key      Deduplication key"
  print "  -p, --persist  Make notification persistent"
}

# Main entry point
def main [...args] {
  if ($args | is-empty) {
    main help
  } else {
    let cmd = ($args | first)
    match $cmd {
      "help" | "--help" | "-h" => { main help }
      _ => {
        print -e $"Unknown command: ($cmd)"
        print -e "Run 'unotify help' for usage."
        exit 1
      }
    }
  }
}
