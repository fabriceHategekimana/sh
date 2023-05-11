#!/home/fabrice/.cargo/bin/nu

# création du projet
def	new [name] {
	mkdir $"($name)/target"
	mkdir $"($name)/src"
	touch $"($name)/questions.txt"
	touch $"($name)/slides.txt"
	touch $"($name)/($name).md"
	cp /home/fabrice/note/templates/ppm.toml $"($name)/ppm.toml"
	sed -i -e $"s/NAME/($name)/" $"($name)/ppm.toml"
} 

def	is_there [path] {
	not (ls $path | where name =~ ppm.toml | is-empty)
} 

def	join_path [list, taken] {
	$list | take $taken | reduce --fold "" { |x acc| echo $"($acc)/($x)" }
} 

def	get_reversed_indices [list] {
	1..($list | length) | reverse
} 

def	is_not_found [splited_path, index] {
	let joined_path = (join_path $splited_path $index)
	let res = not (is_there $joined_path)
	not (is_there (join_path $splited_path $index))
} 

def	find_root_directory [] {
	let splited_path = (pwd | split row "/" | skip)
	let reversed_indices = get_reversed_indices $splited_path
	let search_result = ($reversed_indices | skip while { 
		|index| is_not_found $splited_path $index})
	
	if ($search_result | is-empty) {
		echo "error: no ppm.toml found"
	} else {
#let position = (($splited_path | length) - $search_result.0)
		let position = $search_result.0
		let config_path = (join_path $splited_path $position)
		$config_path
	}
} 

def	compile [root, output_name, format] {
	let source = $"($root)/($output_name).md"
	if $format == "pptx" {
		let destination = $"($root)/target/($format)/($output_name).pptx"
		mkdir $"($root)/target/($format)/"
		pandoc $source -o $destination
   	}
#else if $format == "reveal" {
#let destination = $"($root)/target/($format)/($output_name).md"
#cp -r /home/fabrice/install/reveal $"($root)/target/($format)/"
#pandoc -t html5 --template=/home/fabrice/note/templates/revealjs.html --standalone --section-divs --variable theme="black" $source -o $destination
#} else if $format == "estiam" {
#let outdir = $"($root)/target/($format)/"
#mkdir $"($root)/target/($format)/"
#pandoc ($source) -o ($destination) --reference-doc /home/fabrice/note/templates/Estiam.pptx
#libreoffice --convert-to pdf ($destination) --outdir ($outdir) 
#} else {
#echo "unrecognized"
#}
} 

def build [] {
	compose
	let root = (find_root_directory)
	let config_file = (open $"($root)/ppm.toml")
	let output_name = $config_file.configs.title
	let formats = $config_file.configs.formats
	
	# do the conversion
	$formats | each { |x| compile $root $output_name $x }
} 

# combine the slides in the specified order in slides.txt
def	compose [] {
	let root = (find_root_directory)
	let config_file = (open $"($root)/ppm.toml")
	let output_name = $config_file.configs.title
	let file_name = $"($root)/($output_name).md"
	rm $file_name
	touch $file_name
	cat $"($root)/slides.txt" | lines | each { 
		|x| cat $"($root)/src/($x)" | save --append $"($file_name)" }
} 

def	update [] {
	let root = (find_root_directory)
	let slide_list = $"($root)/slides.txt"
	rm $slide_list
	^ls -t $"($root)/src" | to text | save $slide_list
} 

def	questions [] {
	let root = (find_root_directory)
	chatgread $"($root)/questions.txt"
} 

def main [...params] {
	if ($params | length) == 0 {
		echo "must give arguments [new, build]"
	} else if ($params.0) =~ new {
		new ($params.1) 
	} else if ($params.0) =~ build {
		build 
	} else if ($params.0) =~ update {
		update
	} else if ($params.0) =~ compose {
		compose
	} else if ($params.0) =~ questions {
		questions
	} else if ($params.0) =~ test {
			is_there /home/fabrice/temp/machine_learning/src/other
	} else {
		echo "this command doesn't exist.
			Avaliables commands:
			- new
			- build
			- update
			- compose
			- questions"
	}
}
