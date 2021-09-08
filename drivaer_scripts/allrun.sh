#!/bin/bash

### BEGIN user parameters

mesh=${1:-S}
num_proc=${2:-$SLURM_NPROCS}
ppn=${3:-120}
#ppn=$SLURM_NTASKS_PER_NODE

### END user parameters

# Calculate numa topology
numa_nodes=$(numactl -H|grep available|awk '{print $2}')
ranks_per_numa=$(( ppn / numa_nodes ))
MPIFLAGS="-np $num_proc $(env |grep FOAM | cut -d'=' -f1 | sed 's/^/-x /g' | tr '\n' ' ') -x MPI_BUFFER_SIZE --report-bindings --map-by ppr:${ranks_per_numa}:numa"

foamDictionary -entry numberOfSubdomains -set "$num_proc" system/decomposeParDict

nRefine=0
case "$mesh" in
    S)  ;;
    M)  nRefine=1 ;;
    L)  nRefine=2 ; foamDictionary -entry endTime -set 2000 system/controlDict ;;
    XL) nRefine=3 ; foamDictionary -entry endTime -set 2000 system/controlDict ;;
    *)  echo "Invalid mesh size value '$mesh' <S|M|L|XL>." ; exit 1 ;;
esac

blockMesh | tee log.blockMesh

decomposePar -copyZero | tee log.decomposePar

r=0
while [ $r -lt $nRefine ]; do
    echo "Refining the background mesh. Iteration $r"
    mpiexec $MPIFLAGS refineMesh -overwrite | tee -a log.refineMesh
    r=$(( r + 1 ))
done

# echo "Switching to ptscotch for dynamic load balancing with snappyHexMesh"
# setKeyword method ptscotch system/decomposeParDict

mpiexec $MPIFLAGS snappyHexMesh -parallel -overwrite | tee log.snappyHexMesh

mpiexec $MPIFLAGS checkMesh -parallel | tee log.checkMesh

mpiexec $MPIFLAGS simpleFoam -parallel | tee log.simpleFoam

# runApplication reconstructParMesh -constant
# runApplication reconstructPar -latestTime
