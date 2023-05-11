#!/bin/bash

source ~/sh/workflow_module/classic

function select_algo {
	algo=$(get_algo)
	result=$(echo $algo | rofi -dmenu -sep " ")
	echo $result
}
  
# get input
if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
	echo "
parameters:
- create: create a resource from preexisting workflows
- new:    create a new workflow 
- edit:   edit an existing workflow 
- lf:     open the workflow's folder with lf'"
elif [[ "$1" == "create" ]]; then
	result=$(select_algo)
	$module/algos/$result/$result
elif [[ "$1" == "new" ]]; then
	create_algo	
elif [[ "$1" == "edit" ]]; then
	result=$(select_algo)
	vim ~/sh/workflow_module/algos/$result/$result
elif [[ "$1" == "schema" ]]; then
	vim ~/sh/workflow_module/algos/$result/schema.puml
elif [[ "$1" == "lf" ]]; then
	lf ~/$module/algos
else
	echo "unknown input $@"
fi
