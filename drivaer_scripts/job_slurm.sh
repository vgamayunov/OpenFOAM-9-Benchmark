#!/bin/bash

# SLURM job script to do a single run for parametric sweep
# Arguments:
#  1. Directory where the workload files and scripts are located
#  2. Mesh size
#  3. Number of MPI ranks per node
#

script_dir=$1
mesh=$2
ppn=$3

num_proc=(( SLURM_NNODES * ppn ))

cp -rv $script_dir/../drivaerFastback .
cd drivaerFastback

source $script_dir/setenv.sh

$script_dir/allrun.sh $mesh $num_proc $ppn

# Extract snappyHexMesh and solver times

grep "Finished meshing in" log.snappyHexMesh
grep "ExecutionTime" log.simpleFoam | tail -1
