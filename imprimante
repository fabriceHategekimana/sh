#!/bin/bash

if [ -z "$1" ]; then
	STR=$(lpstat -p)
	#IFS=''
	#read -ra LIGNE <<< $(echo "$STR")
	#compteur=0
	echo "$STR"
	for element in "$STR";
	do
		#SUBSTR=$(echo $element | cut -d'.' -f 1)
		#echo $SUBSTR
		echo "$element"
		echo "------------------------------"
		((compteur++))
	done
	echo $compteur
else
	#lpadmin -x [imprimante]
fi
