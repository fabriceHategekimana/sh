#!/home/fabrice/.cargo/bin/nu

let target = (^ls /home/fabrice/tunnel | rofi -dmenu)

open /home/fabrice/sh/variables/current_project.toml | update folder $"/home/fabrice/tunnel/($target)" | save -f /home/fabrice/sh/variables/current_project.toml

