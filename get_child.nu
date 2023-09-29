#!/home/fabrice/.cargo/bin/nu


def to_list [record] {
	let rec_to_list2 = {|key, value| 
			[$key, ($value | into string)]
	}

	let rec_to_list1 = {|key, value| 
			[$key, ($value | items $rec_to_list2)]
	}

	$record | items $rec_to_list1 | flatten | flatten | flatten
}

def main [] {
	{ a: {aa: 35.7, ab: 0}, b: {ba: 7, bb: 12} } | to_list $in | filter {|x| $x | $in =~ "[0-9]" }
}

