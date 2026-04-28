#!/bin/bash
#SBATCH --job-name=lib001_coverage
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --output=./slurm_output/lib001_coverage.%j.stdout
#SBATCH --error=./slurm_output/lib001_coverage.%j.stderr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --qos=default
#SBATCH --partition=cpuq


module load EBModules Anaconda3/2022.05
conda init bash
source activate PacBio
source /etc/profile.d/slurm_tmpdir.sh

pbmm2 align /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning/library001_ris_sensative_smn2_2xinner_2xbc.fasta.mmi /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2011.bam $SLURM_TMPDIR/bc2011.aligned.lib001.bam --preset CCS 
samtools sort -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam -@ 22 $SLURM_TMPDIR/bc2011.aligned.lib001.bam
samtools index -@ 22 -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam.bai /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam
samtools depth -a -H -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.coverage /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam