#!/bin/sh

#SBATCH --partition=cpu-t3
#SBATCH --job-name=convertXMLtoWFDB
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=2		# Number of cores per task
#SBATCH --array=1-21
#SBATCH --error=slurm-%A-%a.err
#SBATCH --output=slurm-%A-%a.out
#SBATCH --mail-user=ashah282@uic.edu
#SBATCH --mail-type=END

printf 'Load modules\n'
module load R/4.2.1-foss-2022a

# There needs to be a job for each folder in MUSE (e.g. 20)
# Slurm IDs for each task to help tell us what is going on
config=/shared/home/ashah282/projects/cbcd/config-muse.txt
sample=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)
echo "This is array task ${SLURM_ARRAY_TASK_ID}, processing ECG from the ${sample} folder"

# Parallel conversion to be run everytime
# Followed by updating contents of folders
Rscript R/convert-xml2wfdb.R $sample

# Afterwards, need to clean up and document files
# Simple script that should take very little time to run
Rscript R/config-wfdb.R
