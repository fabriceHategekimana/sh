#!/home/fabrice/.cargo/bin/nu

def write_chapters [chapters] {
	touch chapters
	$chapters | each { |x| echo $x | save -a chapters }
}

def create_jour [course_name: string, jour: string] {
	mkdir $jour	
	cd $jour
	write_chapters $chapters
	/home/fabrice/sh/reveal
	mv reveal $course_name
	mkdir exercices
}

def create_jours [syllabus: record] {
	let jours = (get_jours $syllabus)
	$jours | each { |x| create_jour $x }
}

def main [argument] {
	if ($argument == "init"){
		cp /home/fabrice/sh/cours_module/syllabus.yaml .
	} else {
		let syllabus = (open syllabus.yaml)
		create_jours $syllabus
	}
}
