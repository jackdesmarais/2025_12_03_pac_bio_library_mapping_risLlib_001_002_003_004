#!/bin/bash
#SBATCH --job-name=mm2_bc2015_plasmid_align
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --output=./slurm_output/mm2_bc2015_plasmid_align.%j.stdout
#SBATCH --error=./slurm_output/mm2_bc2015_plasmid_align.%j.stderr
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --qos=default
#SBATCH --partition=gpuq
#SBATCH --gres=gpu:v100:1

set -euo pipefail

# Align BC2021 HiFi reads to the ELP1 plasmid reference using minimap2.
# Steps:
# 1) Convert BAM -> FASTQ with samtools (per convert_bam_to_fastq.sh).
# 2) Align FASTQ -> FASTA with minimap2 (per make_test_data_minimap2_lowNscore_alignment.sh).
# 3) Sort + index the alignment in temp space.
# 4) Write flagstat and depth coverage to the aligning directory.
# 5) Copy the final sorted BAM (+ index) to the aligning directory.
# All intermediate files are stored in SLURM_TMPDIR if set, otherwise /tmp.

module load EBModules Anaconda3/2022.05
conda init bash
source activate PacBio
source /etc/profile.d/slurm_tmpdir.sh

ALIGN_DIR="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning"
INPUT_BAM="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2015.bam"
REFERENCE_FASTA="${ALIGN_DIR}/library001_ris_sensative_smn2_2xinner_2xbc_rotated.fasta"

READ_NAME="bc2015"
TARGET_NAME="lib001_rotated"

OUTPUT_BAM="${ALIGN_DIR}/${READ_NAME}.${TARGET_NAME}.minimap2_lowNscore_aligned.sorted.bam"
OUTPUT_DEPTH="${ALIGN_DIR}/${READ_NAME}.${TARGET_NAME}.minimap2_lowNscore_aligned.depth"
OUTPUT_FLAGSTAT="${ALIGN_DIR}/${READ_NAME}.${TARGET_NAME}.minimap2_lowNscore_aligned.flagstat.txt"

TMPDIR="${SLURM_TMPDIR:-/tmp}"
echo "Temporary directory: ${TMPDIR}"
if [ ! -d "${TMPDIR}" ]; then
    echo "Error: temp directory does not exist: ${TMPDIR}"
    exit 1
fi

mkdir -p "${ALIGN_DIR}/slurm_output"

if [ ! -f "${INPUT_BAM}" ]; then
    echo "Error: Input BAM file not found: ${INPUT_BAM}"
    exit 1
fi

if [ ! -f "${REFERENCE_FASTA}" ]; then
    echo "Error: Reference FASTA file not found: ${REFERENCE_FASTA}"
    exit 1
fi

echo "Temporary directory: ${TMPDIR}"
echo "Converting BAM to FASTQ..."

FASTQ_PATH="${TMPDIR}/${READ_NAME}.fastq.gz"
samtools fastq "${INPUT_BAM}" > "${FASTQ_PATH}"

echo "Aligning reads with minimap2..."
RAW_BAM="${TMPDIR}/${READ_NAME}.${TARGET_NAME}.minimap2_lowNscore_aligned.bam"
minimap2 -ax map-hifi "${REFERENCE_FASTA}" "${FASTQ_PATH}" --score-N 0 > "${RAW_BAM}"

echo "Sorting and indexing alignment..."
samtools sort -o "${TMPDIR}/aligned.sorted.bam" "${RAW_BAM}"
samtools index "${TMPDIR}/aligned.sorted.bam"

echo "Writing flagstat to ${OUTPUT_FLAGSTAT}..."
samtools flagstat "${TMPDIR}/aligned.sorted.bam" > "${OUTPUT_FLAGSTAT}"

echo "Writing depth coverage to ${OUTPUT_DEPTH}..."
samtools depth -a -H -o "${OUTPUT_DEPTH}" "${TMPDIR}/aligned.sorted.bam"

echo "Copying final alignment to ${OUTPUT_BAM}..."
cp -f "${TMPDIR}/aligned.sorted.bam" "${OUTPUT_BAM}"
cp -f "${TMPDIR}/aligned.sorted.bam.bai" "${OUTPUT_BAM}.bai"

echo "Done."

