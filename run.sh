#!/bin/bash

cp -rv $HOME/OpenFOAM/OpenFOAM-9/tutorials/incompressible/simpleFoam/drivaerFastback .
cd drivaerFastback

./Allrun -m S -c $SLURM_NPROCS

grep "Finished meshing in" log.snappyHexMesh
grep "ExecutionTime" log.simpleFoam | tail -1

