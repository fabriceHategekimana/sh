#!/home/fabrice/.cargo/bin/nu

def main [command] {
	let path = "/home/fabrice/sh"
	let file = $"($path)/($command)"
	mv $"($file)" $"($file).nu"
	ln -s $"($file).nu" $"($file)"
}
