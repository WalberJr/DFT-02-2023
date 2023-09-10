#!/bin/bash

echo "Atualizando o sistema."
apt-get update && apt-get update 
sleep 2s

echo "Instalando as bibliotecas."
apt-get install autoconf build-essential ca-certificates gfortran gcc mpich libblas3 libc6 fftw3-dev libfftw3-dev libgcc-s1 liblapack-dev wget libopenmpi-dev libscalapack-openmpi-dev libelpa17
sleep 2s

################# openmpi  ######################
# Download
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.gz
# Extract files
tar -xvf openmpi-4.0.3.tar.gz

# Instaling
cd openmpi-4.0.3
./configure --prefix=/usr/local/openmpi-4.0.3
make install
cd ../

echo 'export PATH=$PATH:/usr/local/openmpi-4.0.3/bin' >>  ~/.bashrc


################# LAPACK ###################

# Downloading
wget https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz
# Extract files
tar -xvf v3.9.0.tar.gz

# Instaling
cd  lapack-3.9.0

cp make.inc.example make.inc

make blaslib
make lapacklib
make tmglib

cp librefblas.a /usr/local/lib/libblas.a
cp liblapack.a /usr/local/lib/liblapack.a
cp libtmglib.a /usr/local/lib/libtmg.a
#======================================================================================
cd ../
echo "Download e Instalção do QE"
wget https://gitlab.com/QEF/q-e/-/archive/qe-7.2/q-e-qe-7.2.tar.gz 
tar -zxvf q-e-qe-7.2.tar.gz 
cd q-e-qe-7.2 
./configure --enable-parallel=yes --enable-openmp=yes F90=mpifort F77=mpifort MPIF90=mpifort CC=mpicc
make -j2 all 
echo 'export PATH="/root/q-e-qe-7.2/bin:$PATH"' >> ~/.bashrc

mkdir PSEUDO
cd PSEUDO/
wget https://www.physics.rutgers.edu/gbrv/all_lda_UPF_v1.5.tar.gz
wget https://www.physics.rutgers.edu/gbrv/all_pbe_UPF_v1.5.tar.gz
wget https://www.physics.rutgers.edu/gbrv/all_pbesol_UPF_v1.5.tar.gz
tar -zxvf all_lda_UPF_v1.5.tar.gz
tar -zxvf all_pbe_UPF_v1.5.tar.gz
tar -zxvf all_pbesol_UPF_v1.5.tar.gz
#
rm -rf all_lda_UPF_v1.5.tar.gz all_pbe_UPF_v1.5.tar.gz all_pbesol_UPF_v1.5.tar.gz
sleep 2s

echo "Tudo Ok"
