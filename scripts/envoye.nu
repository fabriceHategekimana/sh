#!/home/fabrice/.cargo/bin/nu

def main [] {
	let first_image = (ls /home/fabrice/Images/memes_WeData/diffusion/a_envoyer/ | $in.0.name)
	mv $first_image /home/fabrice/Images/memes_WeData/diffusion/fait/
}
