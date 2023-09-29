#!/home/fabrice/.cargo/bin/nu

use profile.nu
use event_logger.nu

let DATAS = "/home/fabrice/sh/game_src/taches.csv"
let PROFIL = "/home/fabrice/sh/game_src/profil.toml"

def create_task [nom: string, description: string, tags: string, projet: string, etat: string, points: string, due: string] {
	open $DATAS | append { 
				 nom: $nom,
				 description: $description,
				 tags: $tags,
				 projet: $projet,
				 etat: $etat,
				 points: $points,
				 due: $due 
	} | save -f $DATAS
}

def add_task [nom: string] {
	create_task $nom "-" "-" "-" "todo" "5" "-"
}

def delete_task [nom: string] {
	open $DATAS | where nom != $nom | save -f $DATAS
}

def add_task_module [ast: list] {
	if ($ast | length) == 1 {
		add_task $ast.0
	} else if $ast.1 =~ "[0-9]+" {
		create_task $ast.0 "-" "-" "-" "todo" $ast.1 "-"
	} else if $ast.1 == rec {
		create_task $ast.0 "-" "recurring" "-" "todo" "5" "-"
	}
}

def add_module [ast: list] {
	if $ast.0 == task {
		add_task_module ($ast | skip 1)
	} else if $ast.0 == tasks {
		$ast | skip 1 | each { |x| add_task $x }
	}
}

def delete_module [ast: list] {
	if $ast.0 == task {
		delete_task $ast.1
	} else if $ast.0 == tasks {
		$ast | skip 1 | each { |x| delete_task $x }
	}
}

def get_name_from_index [index: int] {
	simple_show | get nom | first (($index | into int) + 1) | last 1
}

def set_verb [ast: list] {
	# column = ast.2, value = ast.3
	open $DATAS | update $ast.2 { |x|
		if $x.nom == $ast.0 {
			$ast.3
		} else {
			($x | get $ast.2)
		}
	}
}

def add_verb [ast: list] {
	open $DATAS | update $ast.2 { |x|
		if $x.nom == $ast.0 {
			($x | get $ast.2) + ($ast.3 | into int)
		} else {
			($x | get $ast.2)
		}
	}
}

def minus_verb [ast: list] {
	open $DATAS | update $ast.2 { |x|
		if $x.nom == $ast.0 {
			($x | get $ast.2) - ($ast.3 | into int)
		} else {
			($x | get $ast.2)
		}
	}
}

def append_verb [ast: list] {
	open $DATAS | update $ast.2 { |x|
		if $x.nom == $ast.0 {
			$"(($x) | get ($ast).2) ; ($ast.3)"
		} else {
			($x | get $ast.2)
		}
	}
}

def done_verb [ast: list] {
	# column = ast.2, value = ast.3
	open $DATAS | update etat { |x|
		if $x.nom == $ast.0 {
			profile add_exp ($x.points | into int)
			if $x.tags =~ "recurring" {
				$x.etat	
			} else {
				"done"
			}
		} else {
			$x.etat
		}
	}
}

def verb_module [ast: list] {
	if ($ast | length) == 1 {
		simple_show | where nom == $ast.0	
	} else if $ast.1 == "set" {
		set_verb $ast | save -f $DATAS
		simple_show
	} else if $ast.1 == "add" {
		add_verb $ast | save -f $DATAS
		simple_show
	} else if $ast.1 == "minus" {
		minus_verb $ast | save -f $DATAS
		simple_show
	} else if $ast.1 == "append" {
		append_verb $ast | save -f $DATAS
		simple_show
	} else if $ast.1 == "done" {
		done_verb $ast | save -f $DATAS
		simple_show
	}
}

def target_module [ast: list] {
	if $ast.0 =~ "^[0-9]+" {
		verb_module ((get_name_from_index $ast.0) ++ ($ast | skip 1))
	} else {
		verb_module ($ast)
	}	
}

def simple_show [] {
	open $DATAS | where etat == todo
}

def show_module [ast: list] {
	if ($ast | is-empty) {
		simple_show
	} else {
		mut res = (simple_show)
		mut ast_mut = $ast
		while ($ast_mut | is-empty) == false {
			let two_first = ($ast_mut | take 2)
			$res = ($res | where { |x| ($x | get $two_first.0) == $two_first.1 }) 
			$ast_mut = ($ast_mut | skip 2)
		}
		$res
	}
}

def reset_module [ast: list] {
	if $ast.0 == "profile" {
		profile reset
		profile get_status
	}
}

def main [command: string] {
	let ast = ($command | split row " ")
	if $ast.0 == "add" {
		add_module ($ast | skip 1)	
		simple_show
	} else if $ast.0 == "delete" {
		delete_module ($ast | skip 1)
		simple_show
	} else if $ast.0 == "show" {
		show_module ($ast | skip 1)
	} else if $ast.0 == "task" {
		target_module ($ast | skip 1)
	} else if $ast.0 == "profile" {
		profile get_status
	} else if $ast.0 == "reset" {
		reset_module ($ast | skip 1)
		simple_show
	} else if $ast.0 == "all" {
		open $DATAS
	} else if $ast.0 == "log" {
		event_logger get_log
	} else if $ast.0 == help {
		echo "commands:
	add [type]
	delete [type]
	show
	task [name/id] [verb] [column] [value]"
	}

	event_logger add_event $command cmd
}
