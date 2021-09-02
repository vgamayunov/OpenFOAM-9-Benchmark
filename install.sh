#!/bin/bash

cd $HOME
mkdir OpenFOAM
cd OpenFOAM
git clone git://github.com/OpenFOAM/OpenFOAM-9.git
git clone git://github.com/OpenFOAM/ThirdParty-9.git

cat <<EOF >setenv.sh
source /etc/profile
MY_DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
module load gcc-9.2.0
module load mpi/hpcx
. \$MY_DIR/OpenFOAM-9/etc/bashrc
EOF

source setenv.sh
cd OpenFOAM-9
ncores=$(cat /proc/cpuinfo | grep ^processor | wc -l)
./Allwmake -j $ncores 2>&1 | tee build.log

