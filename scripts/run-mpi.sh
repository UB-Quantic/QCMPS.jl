#!/bin/bash

SCRIPT=()

while [[ $# -gt 0 ]]
do
	case $1 in
		--project)
			PROJECT="--project=$2"
			shift
			;;
		-np)
			NP="$2"
			shift
			;;
		--extrae)
			export EXTRAE_CONFIG_FILE=extrae.xml
			export LD_PRELOAD=${EXTRAE_HOME}/lib/libompitrace.so
			;;
		*)
			SCRIPT+="$1 "
			;;
	esac

	shift
done

mpiexecjl $PROJECT -np $NP julia $SCRIPT