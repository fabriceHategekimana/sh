all:start

start: FORCE
	bash workflow "- faire hacking lab :: [etape]"

command: FORCE
	cat Makefile | grep ": FORCE" | sed "s/: FORCE//" | grep --invert-match "FORCE" 

commands: FORCE
	cat Makefile | grep ": FORCE" | sed "s/: FORCE//" | grep --invert-match "FORCE" 

FORCE:
