#!/bin/bash
set -euo pipefail
# Submits a number of jobs to perform parameter sweep.
# The example submits jobs using SLURM and HBv3 VM

# User variables
openfoam_dir=$HOME/OpenFOAM
run_dir=$(pwd)/run
# End of user variables

ln -sfv $openfoam_dir/setenv.sh
mkdir -pv $run_dir

# arguments: partition <run_dir> <mesh_size> <num_nodes> <ranks_per_node> <total_cores_per_node>
./submit_slurm_single.sh hbv3 $run_dir L 2 120 120
#./submit_slurm_single.sh hbv3 $run_dir L 2 96 120
#./submit_slurm_single.sh hbv3 $run_dir L 2 64 120
