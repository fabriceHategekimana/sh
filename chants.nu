#!/home/fabrice/.cargo/bin/nu

def format_name [name] {
	$name | str replace -a " " "_" | str replace -a "'" " " | str replace -a "-" " "
}

def main [command] {
	if $command == "open" {
		let chant_formated = (format_name $chant)
		echo $"($chant_formated)"
	} else {
		echo "Error: can't recognize the '($command)' command"
	}
}

