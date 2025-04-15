all:start

start: clear
	echo "Hello world!"

new: clear
	mv bilan.toml src/$$(date +"%d_%m_%Y").toml && cp template.toml bilan.toml

clear: FORCE
	clear

FORCE:
