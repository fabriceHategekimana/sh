#!/home/fabrice/.cargo/bin/nu

source /home/fabrice/.config/zoxide/config.nu

# jump to a specific place and lf
def main [path: string] {
	z $path
	lf	
}

