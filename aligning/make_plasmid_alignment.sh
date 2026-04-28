#!/bin/bash
#SBATCH --job-name=lib001_alignment
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --output=./slurm_output/lib001_alignment.%j.stdout
#SBATCH --error=./slurm_output/lib001_alignment.%j.stderr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --qos=default
#SBATCH --partition=cpuq

module load EBModules Anaconda3/2022.05
conda init bash
source activate PacBio


pbmm2 index /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning/library001_ris_sensative_smn2_2xinner_2xbc.fasta /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning/library001_ris_sensative_smn2_2xinner_2xbc.fasta.mmi
pbmm2 align /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning/library001_ris_sensative_smn2_2xinner_2xbc.fasta.mmi /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2011.bam /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.bam --preset CCS 
samtools flagstat /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.bam
samtools sort -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.bam
samtools index /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam
samtools sort -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam -@ 22 /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.bam
samtools index -@ 22 -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam.bai /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam
samtools coverage -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.coverage /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.lib001.sorted.bam

