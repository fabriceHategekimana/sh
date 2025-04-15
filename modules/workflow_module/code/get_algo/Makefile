all:start

start: FORCE
	python3 parse.py - faire le rapport :: Notebook

compile: FORCE
	ghc -o get_algo get_algo.hs

get: compile
	./get_algo etape

command: FORCE
	cat Makefile | grep ": FORCE" | sed "s/: FORCE//" | grep --invert-match "FORCE" 

commands: FORCE
	cat Makefile | grep ": FORCE" | sed "s/: FORCE//" | grep --invert-match "FORCE" 

FORCE:
