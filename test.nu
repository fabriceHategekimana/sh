#!/home/fabrice/.cargo/bin/nu

use nu_modules/core.nu

def main [entry] {
	let val = (core read)
	echo $"ret: ($val)"
	echo $"entry: ($entry)"
}
