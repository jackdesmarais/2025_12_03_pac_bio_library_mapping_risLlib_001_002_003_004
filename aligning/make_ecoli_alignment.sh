#!/bin/bash
#SBATCH --job-name=ecoli_alignment
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --output=./slurm_output/ecoli_alignment.%j.stdout
#SBATCH --error=./slurm_output/ecoli_alignment.%j.stderr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --qos=default
#SBATCH --partition=cpuq

module load EBModules Anaconda3/2022.05
conda init bash
source activate PacBio

pbmm2 align /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning/Escherichia_coli_strain_BTH101_CP070482.fasta.mmi /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2011.bam /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.bam --preset CCS 
samtools flagstat /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.bam
samtools sort -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.sorted.bam /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.bam
samtools index /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.sorted.bam
samtools sort -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.sorted.bam -@ 22 /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.bam
samtools index -@ 22 -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.sorted.bam.bai /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.sorted.bam
samtools coverage -o /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.coverage /grid/kinney/home/desmara/PacBioMapping/Jack/bc2011.aligned.ecoli.sorted.bam

