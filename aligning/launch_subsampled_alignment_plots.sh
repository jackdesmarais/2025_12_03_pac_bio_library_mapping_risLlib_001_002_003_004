ALIGN_DIR="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/aligning"
SCRIPT="/grid/kinney/data/desmara/pacbio_regex_parser/bin/mm2_aligning_subsampled_bam_to_reference.sh"
REFERENCE_FASTA="${ALIGN_DIR}/library001_ris_sensative_smn2_2xinner_2xbc_rotated.fasta"

mkdir -p "${ALIGN_DIR}/slurm_output"

cd "${ALIGN_DIR}"

sbatch "${SCRIPT}" \
  --input-bam "/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2011.bam" \
  --reference-fasta "${REFERENCE_FASTA}" \
  --output-dir "${ALIGN_DIR}" \
  --read-name "bc2011" \
  --target-name "lib001_rotated" \
  --num-reads 10000

sbatch "${SCRIPT}" \
  --input-bam "/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2015.bam" \
  --reference-fasta "${REFERENCE_FASTA}" \
  --output-dir "${ALIGN_DIR}" \
  --read-name "bc2015" \
  --target-name "lib001_rotated" \
  --num-reads 10000

