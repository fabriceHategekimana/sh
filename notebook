#!/home/fabrice/.cargo/bin/nu

def main [type, target] {
	if $type == "pdf" {
		jupyter nbconvert --to pdf $target
	} else if $type == "ipynb" {
		jupytext --to notebook $target 
	} else if $type == "md" {
		jupytext --to myst $target
	}
}

