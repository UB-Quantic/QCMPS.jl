#!/bin/bash

SCRIPT=()

while [[ $# -gt 0 ]]
do
	case $1 in
		--project)
			export PROJECT="--project=$2"
			shift
			;;
		-np)
			export NP="$2"
			shift
			;;
		*)
			SCRIPT+="$1 "
	esac

	shift
done

mpiexecjl $PROJECT -np $NP julia $SCRIPT