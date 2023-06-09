#!/bin/bash

#SBATCH --partition=cpu-t3
#SBATCH --qos=short
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1 		# Number of cores per task
#SBATCH --error=slurm-%J.err
#SBATCH --output=slurm-%J.out

printf 'Load modules with R > 4.0\n'
module load R/4.1.2-foss-2021b 
echo $PWD

# Rscript that shouldn't fail...
Rscript --vanilla /shared/home/ashah282/projects/cbcd/tests/sandbox/test-simple.R

Rversion=$(R --version)
echo $Rversion
