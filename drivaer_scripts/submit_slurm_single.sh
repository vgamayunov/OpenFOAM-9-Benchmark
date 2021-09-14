#!/bin/bash

# Submits a SLURM job for parametric sweep.
# Arguments:
#  1. SLURM partition name
#  2. Running directoty
#  3. Mesh size. Values: <S|M|L|XL>
#  4. Number of nodes
#  5. Number of MPI ranks per node
#  6. Total number of cores per node

partition=$1
rundir=$2
mesh=$3
num_nodes=$4
ppn=$5
cores_per_node=${6:-120}

mydir=$(pwd)
workdir=$rundir/run.${partition}.N${num_nodes}.ppn${ppn}
mkdir -pv $workdir
cd $workdir
sbatch -p $partition -N $num_nodes --ntasks-per-node=$cores_per_node $mydir/job_slurm.sh $mydir $mesh $ppn
