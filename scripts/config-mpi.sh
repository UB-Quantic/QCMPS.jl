#!/bin/sh

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
    esac

    shift
done

julia -e "using Pkg; Pkg.build("MPI"; verbose=true)"
if ["$MPIEXECJL_INSTALL" = true]; then julia -e "using MPI; MPI.install_mpiexecjl()" fi