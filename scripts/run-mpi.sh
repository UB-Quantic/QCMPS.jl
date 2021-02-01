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
		--extrae)
			export EXTRAE_CONFIG_FILE=extrae.xml
			export LD_PRELOAD=${EXTRAE_HOME}/lib/libompitrace.so
			shift
			;;
		*)
			SCRIPT+="$1 "
	esac

	shift
done

mpiexecjl $PROJECT -np $NP julia $SCRIPT