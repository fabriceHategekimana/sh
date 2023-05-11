#!/home/fabrice/.cargo/bin/nu

def main [image_name] {
	let target_folder = (open /home/fabrice/sh/variables/current_project.toml | get folder)
	notify-send $target_folder 
	import $"($target_folder)/images/($image_name).png"
}

