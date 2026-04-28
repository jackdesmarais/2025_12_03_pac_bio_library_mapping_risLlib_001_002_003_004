#!/bin/bash
#SBATCH --job-name=ecoli_coverage
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --output=./slurm_output/ecoli_coverage.%j.stdout
#SBATCH --error=./slurm_output/ecoli_coverage.%j.stderr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --qos=default
#SBATCH --partition=cpuq




module load EBModules Anaconda3/2022.05
conda init bash
source activate PacBio

samtools depth -a -H -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.coverage /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.sorted.bam