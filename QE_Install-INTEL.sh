#!/bin/bash
################# Input  ######################
VERSION_QE='7.4.1'
################# System  ######################
echo ""
echo "	Atualizando o sistema."
apt-get update && apt-get update 
echo " "
echo "	Instalando as bibliotecas."
apt-get install autoconf build-essential ca-certificates gfortran gcc mpich libblas3 libc6 fftw3-dev libfftw3-dev libgcc-s1 liblapack-dev wget libopenmpi-dev libscalapack-openmpi-dev libelpa17
echo " "
################# Intel® oneAPI for Linux* OS  ######################
# Download
echo " Download Intel® oneAPI"
wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/cca951e1-31e7-485e-b300-fe7627cb8c08/intel-oneapi-base-toolkit-2025.1.0.651_offline.sh

wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/d0df6732-bf5c-493b-a484-6094bea53787/intel-oneapi-hpc-toolkit-2025.1.0.666_offline.sh

wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/306e03be-1259-4d71-848a-59e23013c4f0/intel-fortran-essentials_2025.1.0.556_offline.sh

wget https://registrationcenter-download.intel.com/akdlm/IRC_NAS/0dbea6d6-0e62-4419-b68d-5d658677fce7/intel-cpp-essentials_2025.1.0.571_offline.sh

# Install
echo " Install Intel® oneAPI"
sh ./intel-oneapi-base-toolkit-2025.1.0.651_offline.sh -a --silent --eula accept
sh ./intel-oneapi-hpc-toolkit-2025.1.0.666_offline.sh -a --silent --eula accept
sh ./intel-fortran-essentials_2025.1.0.556_offline.sh -a --silent --eula accept
sh ./intel-cpp-essentials_2025.1.0.571_offline.sh -a --silent --eula accept

source /opt/intel/oneapi/setvars.sh --force &&
#======================================================================================
echo ""
echo "Download e Instalção do QE"
wget https://gitlab.com/QEF/q-e/-/archive/qe-${VERSION_QE}/q-e-qe-${VERSION_QE}.tar.gz 
tar -zxvf q-e-qe-${VERSION_QE}.tar.gz 
cd q-e-qe-${VERSION_QE} 
################# Configurando variáveis  ######################
export FFLAGS='-O3 -xHost -qopenmp -qmkl=parallel' && \\
export CFLAGS='-O3 -xHost -qopenmp' && \\
export CXXFLAGS='-O3 -xHost -qopenmp' && \\
export LDFLAGS='-qmkl=parallel' && \\
./configure --enable-parallel --with-scalapack=intel \\
    CC=icx \\
    CXX=icpx \\
    FC=ifx \\
    F77=ifx \\
    F90=ifx \\
    MPIF90=mpiifx \\
    MPICC=mpiicx \\
    MPICXX=mpiicpx && \\
    make all && \\
    make install

#echo 'export PATH="/root/q-e-qe-${VERSION_QE}/bin:$PATH"' >> ~/.bashrc
################# PSEUDO LIBRARY ######################
mkdir PSEUDO
cd PSEUDO/
wget https://www.physics.rutgers.edu/gbrv/all_lda_UPF_v1.5.tar.gz
wget https://www.physics.rutgers.edu/gbrv/all_pbe_UPF_v1.5.tar.gz
wget https://www.physics.rutgers.edu/gbrv/all_pbesol_UPF_v1.5.tar.gz
tar -zxvf all_lda_UPF_v1.5.tar.gz
tar -zxvf all_pbe_UPF_v1.5.tar.gz
tar -zxvf all_pbesol_UPF_v1.5.tar.gz
# Limpeza
rm -rf all_lda_UPF_v1.5.tar.gz all_pbe_UPF_v1.5.tar.gz all_pbesol_UPF_v1.5.tar.gz
#======================================================================================
sleep 2s
echo ""
echo ""
echo ""
echo " Tudo Ok!"
