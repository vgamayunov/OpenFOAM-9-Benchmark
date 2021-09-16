#!/bin/bash
set -euo pipefail
# Submits a SLURM job for parametric sweep.
# Arguments:
#  1. SLURM partition name
#  2. Running directoty
#  3. Mesh size. Values: <S|M|L|XL>
#  4. Number of nodes
#  5. Number of MPI ranks per node
#  6. Total number of cores per node (default=120)

partition=$1
rundir=$2
mesh=$3
num_nodes=$4
ppn=$5
cores_per_node=${6:-120}

if (( ppn > cores_per_node )); then
    echo "ERROR: Number of MPI ranks per node ($ppn) is greater than the number of cores per node ($cores_per_node)."
    exit 1
fi

mydir=$(pwd)
workdir=$rundir/run.${mesh}.${partition}.N${num_nodes}.ppn${ppn}.$(date +%Y%m%d-%H%M%S)
mkdir -pv $workdir
cd $workdir
sbatch -J drivaer-${mesh}-ppn${ppn} -p $partition -N $num_nodes --ntasks-per-node=$cores_per_node $mydir/job_slurm.sh $mydir $mesh $ppn
