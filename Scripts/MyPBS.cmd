#!/bin/sh
#PBS ?N test_matlab
#PBS -q parallel
#PBS -l walltime=00:10:00
#PBS -l nodes=1:ppn=1
#PBS -j oe

module load matlab
cd $PBS_O_WORKDIR
./TestModelRDMs > ${PBS_JOBNAME}.${PBS_JOBID}
# end of example file