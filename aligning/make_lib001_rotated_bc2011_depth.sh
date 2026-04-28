#!/bin/bash
#SBATCH --job-name=lib001_rotated_bc2011_depth
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --output=./slurm_output/%x.%j.stdout
#SBATCH --error=./slurm_output/%x.%j.stderr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --qos=default
#SBATCH --gres=gpu:v100:1
#SBATCH --partition=gpuq #switching to v100 node for bigger tmpdir

module load EBModules Anaconda3/2022.05
conda init bash
source activate PacBio
source /etc/profile.d/slurm_tmpdir.sh


reference_path=/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning/library001_ris_sensative_smn2_2xinner_2xbc_rotated.fasta
reads_path=/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2011.bam
output_path=/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning/
read_name=bc2011
target_name=lib001_rotated

# index the rotated library
pbmm2 index $reference_path $reference_path.mmi

# align the reads to the rotated library
pbmm2 align $reference_path.mmi $reads_path $SLURM_TMPDIR/$read_name.$target_name.aligned.bam --preset CCS 
samtools flagstat $SLURM_TMPDIR/$read_name.$target_name.aligned.bam > $output_path/$read_name.$target_name.aligned.flagstat.txt

# sort the aligned reads
samtools sort -o $SLURM_TMPDIR/$read_name.$target_name.aligned.sorted.bam $SLURM_TMPDIR/$read_name.$target_name.aligned.bam
samtools index $SLURM_TMPDIR/$read_name.$target_name.aligned.sorted.bam

# calculate the depth
samtools depth -a -H -o $output_path/$read_name.$target_name.aligned.depth $SLURM_TMPDIR/$read_name.$target_name.aligned.sorted.bam