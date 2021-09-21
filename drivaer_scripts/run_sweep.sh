#!/bin/bash
set -euo pipefail
# Submits a number of jobs to perform parameter sweep.
# The example submits jobs using SLURM and HBv3 VM

run_dir=${1:-$(pwd)/run}

mkdir -pv $run_dir

# arguments: partition <run_dir> <mesh_size> <num_nodes> <ranks_per_node> <total_cores_per_node>
./submit_slurm_single.sh hbv3 $run_dir M 2 120 120
./submit_slurm_single.sh hbv3 $run_dir L 2 120 120
./submit_slurm_single.sh hbv3 $run_dir L 2 96 120
./submit_slurm_single.sh hbv3 $run_dir L 2 64 120

# for mesh in M L ; do
#   for nnodes in 2 4 8 ; do
#     for ppn in 120 60 ; do
#       for partition in hbv3 hbv2 ; do
#         ./submit_slurm_single.sh $partition $run_dir $mesh $nnodes $ppn 120
#       done
#     done
#   done
# done
