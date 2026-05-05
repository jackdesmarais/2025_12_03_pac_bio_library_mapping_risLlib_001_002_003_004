#!/bin/bash
# Outer launcher: submits one sbatch job per BAM × reference-mode combination.
# Run directly with bash (not sbatch): bash launch_doubled_subsampled_alignment_plots.sh

set -euo pipefail

REPO_DIR="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/2026_05_04_reanalysis"
REFERENCE_FASTA="${REPO_DIR}/library001_ris_sensative_smn2_2xinner_2xbc.fasta"
OUT_BASE_DIR="${REPO_DIR}/cluster_map/alignment_output"
SLURM_LOG_DIR="${REPO_DIR}/cluster_map/slurm_output"
NUM_READS=10000
THREADS=24

declare -A BAMS=(
    ["bc2011"]="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2011.bam"
    ["bc2015"]="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2015.bam"
    ["unassigned"]="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.unassigned.bam"
)

mkdir -p "${SLURM_LOG_DIR}"
mkdir -p "${OUT_BASE_DIR}"

for READ_NAME in "${!BAMS[@]}"; do
    BAM="${BAMS[$READ_NAME]}"

    for MODE in circular linear; do
        OUT_DIR="${OUT_BASE_DIR}/${READ_NAME}_${MODE}"
        mkdir -p "${OUT_DIR}"

        ALIGN_CMD="pixi run pacbio-align-cluster --input-bams ${BAM} --reference-fasta ${REFERENCE_FASTA} --out-dir ${OUT_DIR} --read-name ${READ_NAME}_${MODE} --num-reads ${NUM_READS} --threads ${THREADS}"
        [[ "${MODE}" == "linear" ]] && ALIGN_CMD="${ALIGN_CMD} --linear-reference"

        sbatch <<SBATCH_SCRIPT
#!/bin/bash
#SBATCH --job-name=align_${READ_NAME}_${MODE}
#SBATCH --mem=100G
#SBATCH --time=10:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=${THREADS}
#SBATCH --qos=cpuq_base
#SBATCH --partition=cpuq
#SBATCH --output=${SLURM_LOG_DIR}/align_${READ_NAME}_${MODE}.%j.stdout
#SBATCH --error=${SLURM_LOG_DIR}/align_${READ_NAME}_${MODE}.%j.stderr

set -euo pipefail
cd ${REPO_DIR}
${ALIGN_CMD}
SBATCH_SCRIPT

        echo "Submitted: ${READ_NAME} (${MODE})"
    done
done

echo "All 6 jobs submitted."
