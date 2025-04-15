#!/home/fabrice/.cargo/bin/nu

export-env {
	$env.LOG = "/home/fabrice/sh/game_src/log.csv"
}

export def add_event [event: string, type: string] {
	open $env.LOG | append {event: $event, type: $type, date: (date now)} | save -f $env.LOG
}

export def get_log [] {
	open $env.LOG
}
