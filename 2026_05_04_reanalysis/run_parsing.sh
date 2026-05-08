#!/bin/bash
#SBATCH --job-name=JJD_parsing_run
#SBATCH --output=/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/2026_05_04_reanalysis/parsing/slurm_launch.%j.stdout
#SBATCH --error=/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/2026_05_04_reanalysis/parsing/slurm_launch.%j.stderr
#SBATCH --time=0:30:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpuq
#SBATCH --qos=cpuq_base

WORKTREE=/grid/kinney/data/desmara/pacbio_regex_parser
OUTPUT_DIR=/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/2026_05_04_reanalysis/parsing

mkdir -p "${OUTPUT_DIR}"

cd "${WORKTREE}"

pixi run python -m pacbio_regex_parser.submit_slurm_jobs \
    --bam-files \
        /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2011.bam /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2015.bam /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.unassigned.bam \
    --regex-patterns "CTGGCTAGCG(.{1,30})GTGCACCTGA" "TCAGGTGCAC(.{1,30})CGCTAGCCAG" "GCTGCCTATC(.{1,100})CTCGAGTCTA" "TAGACTCGAG(.{1,100})GATAGGCAGC" "CATCCAGGTT(.{1,500})AGGAGTAAGT" "ACTTACTCCT(.{1,500})AACCTGGATG" "AGGAGTAAGT(.{1,200})GGTTAAGTTC" "GAACTTAACC(.{1,200})ACTTACTCCT" "CATCCAGGTT(.{1,500})AGGAGTAAGC" "GCTTACTCCT(.{1,500})AACCTGGATG" "AGGAGTAAGC(.{1,200})GGTTAAGTTC" "GAACTTAACC(.{1,200})GCTTACTCCT" "TGGGCAGGTT(.{1,500})AGGACTCCTG" "CAGGAGTCCT(.{1,500})AACCTGCCCA" "CCCTGGGCAGCTCCTGGGCA" "TGCCCAGGAGCTGCCCAGGG" \
      --regex-names "upstream_barcode" "upstream_barcode_rev" "downstream_barcode" "downstream_barcode_rev" "lib001_variable_exon" "lib001_variable_exon_rev" "lib001_variable_intron" "lib001_variable_intron_rev" "lib002_variable_exon" "lib002_variable_exon_rev" "lib002_variable_intron" "lib002_variable_intron_rev" "lib003_variable_exon" "lib003_variable_exon_rev" "lib004_junction" "lib004_junction_rev" \
    --max-regex-length 500 \
    --total-chunks 8 \
    --output-dir "${OUTPUT_DIR}" \
    --count-mem 100G \
    --count-time 1:00:00 \
    --count-cpus 16 \
    --mem 100G \
    --time 1:00:00 \
    --cpus 16 \
    --partition cpuq \
    --qos cpuq_base \
    --merge
