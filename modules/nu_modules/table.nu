#!/home/fabrice/.cargo/bin/nu

export def get_row [csv, column, value] {
	let index = (get_index_from $csv $column $value)
	open $csv | get $index
}

def get_index_from [csv, column, value] {
	open $csv | enumerate | each {|x| if ($x.item | get $column) == $value {$x.index}} | $in.0
}

export def change [csv: string, line, column, value] {	
	open $csv | enumerate | each {
			|x| if $x.index == $line {
				$x.item | update $column $value
			} else {
				$x.item}} | save -f $csv
}

export def change2 [csv: string, column, value, column2, value2] {
	let line = (get_index_from $csv $column $value)
	change $csv $line $column2 $value2
}

export def increment2 [csv: string, column, value, column2, value2] {
	let line = (get_index_from $csv $column $value)
	let previous_value = (open $csv | get $line | get $column2)
	change $csv $line $column2 ($previous_value + $value2)
}

export def decrement2 [csv: string, column, value, column2, value2] {
	let line = (get_index_from $csv $column $value)
	let previous_value = (open $csv | get $line | get $column2)
	change $csv $line $column2 ($previous_value - $value2)
}

export def apply2 [csv: string, column, value, column2, fn] {
	let line = (get_index_from $csv $column $value)
	let previous_value = (open $csv | get $line | get $column2)
	change $csv $line $column2 (do $fn $previous_value)
}

export def add [csv: string, values: list] {
	open $csv | columns | zip $values | each {|x| $"($x.0): ($x.1)"}
}

export def add2 [csv: string, values: record] {
	open $csv | append $values | save -f $csv
}

export def delete2 [csv: string, column, value] {
	let line = (get_index_from $csv $column $value)	
	open $csv | reject $line | save -f $csv
}

export def create_if_not_exist [file_name: string] {
	if (ls | where name == $file_name | length) == 0 {
		touch $file_name	
	}
}
