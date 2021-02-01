#!/bin/sh

VERBOSE=false
while :; do
    case $1 in
		--bin)
			export JULIA_MPI_BINARY="$2"
			shift
			;;
		--path)
			export JULIA_MPI_PATH="$2"
			shift
			;;
		--lib)
			export JULIA_MPI_LIBRARY="$2"
			shift
			;;
		--abi)
			export JULIA_MPI_ABI="$2"
			shift
			;;
		--exec)
			export JULIA_MPIEXEC="$2"
			shift
			;;
		--install)
			MPIEXECJL_INSTALL=true
			;;
		-v|--verbose)
			VERBOSE=true
			;;
    esac

    shift
done

if ["$VERBOSE" = false]; then
	echo "JULIA_MPI_BINARY = $JULIA_MPI_BINARY"
	echo "JULIA_MPI_PATH = $JULIA_MPI_PATH"
	echo "JULIA_MPI_LIBRARY = $JULIA_MPI_LIBRARY"
	echo "JULIA_MPI_ABI = $JULIA_MPI_ABI"
	echo "JULIA_MPIEXEC = $JULIA_MPIEXEC"
	echo "Install mpiexecjl? = $MPIEXECJL_INSTALL"
fi

julia -e "using Pkg; Pkg.build("MPI"; verbose=true)"
if ["$MPIEXECJL_INSTALL" = true]; then julia -e "using MPI; MPI.install_mpiexecjl()" fi