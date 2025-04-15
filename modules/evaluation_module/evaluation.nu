#!/home/fabrice/.cargo/bin/nu

use std assert

def main [command] {
	if ($command == "init") {
		mkdir src
		cp /home/fabrice/note/templates/evaluation/template.yaml src/pondération.yaml
	} else {
		let value = ($command | into float)
		if (is_valid_folder) {
#extract_points "src/groupe_1.yaml" | weightning $in
			let res = (ls src/*.yaml | get name | each { |name|  { name: (extract_name $name), points: (get_points $name), note: (evaluate $name $value) } })
			echo $res
			echo $res | to csv | save -f $"notes_($value).csv" 
		} else {
			echo "missing something: src folder or src/pondération.yaml file"
			echo "try using: evaluation init"
		}
	}
}

def is_valid_folder [] {
	((ls | where name == src | where type == dir | length) == 1) and ((ls src | where name =~ pondération.yaml | length) == 1)
}

def to_list [record] {
	let rec_to_list2 = {|key, value| 
			[$key, ($value | into string)]
	}

	let rec_to_list1 = {|key, value| 
			[$key, ($value | items $rec_to_list2)]
	}
	$record | items $rec_to_list1 | flatten | flatten | flatten
}

def extract_points [ file_name: string ] {
	let file = (open $file_name);
	$file | to_list $in | filter {|x| $x | $in =~ "[0-9]" } | each { |x| $x | into float }
}

def weightning [points] {
	let ponderation_points = extract_points src/pondération.yaml #| $in.0.1 | each {|x| $x.1 | into float}
	$points | zip $ponderation_points | each { || $in.0 * $in.1 }
}

def to_6 [total: float] {
	let max_points = extract_points src/pondération.yaml | math sum
	($total * 6.0) / $max_points
}

def to_value [total: float, value: float] {
	let max_points = extract_points src/pondération.yaml | math sum
	($total * $value) / $max_points
}

def extract_name [file] {
	$file |	str replace "src/" "" | str replace ".yaml" ""
}

def evaluate [file: string, value: float] {
	extract_points $file | weightning $in | math sum | to_value $in $value
}

def get_points [file: string] {
	extract_points $file | weightning $in | math sum
}

