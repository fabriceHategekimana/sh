#!/home/fabrice/.cargo/bin/nu

use	event_logger.nu

export-env {
	$env.PROFILE = "/home/fabrice/sh/game_src/profile.toml"
}

def get_level [] {
	open $env.PROFILE | get level 
}

def level_up [] {
	get_status | update level { |x| $x.level + 1 } | update_status $in
	let current_level = (get_level)
	echo $"Congratulation! Your are now level ($current_level)!"
	nofify-send $"Congratulation! Your are now level ($current_level)!"
	event_logger add_event $"lvl ($current_level)" "level_up"
}

def get_exp [] {
	open $env.PROFILE | get exp 
}

def set_exp [new_exp: int] {
	open $env.PROFILE | update exp $new_exp | update_status $in
}

def update_status [new_status: record] {
	$new_status | save -f $env.PROFILE	
}

export def get_status [] {
	open $env.PROFILE
}

export def add_exp [exp: int] {
	mut new_exp = ((get_exp) + ($exp))
	let current_goal = ((get_level) * 100)
	if $new_exp >= $current_goal {
		level_up
		$new_exp = ($new_exp - $current_goal)
	}
	set_exp $new_exp
	get_status
	event_logger add_event $"+($exp)xp" "xp"
}

export def reset [] {
	get_status | update exp 0 | update level 0 | update_status $in
}
