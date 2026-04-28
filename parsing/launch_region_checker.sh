#!/bin/bash
python /grid/kinney/data/desmara/pacbio_regex_parser/bin/submit_slurm_jobs.py \
      --bam-files /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2011.bam /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.bc2015.bam /grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/hifi_reads/m84223_251126_143521_s2.hifi_reads.unassigned.bam \
      --regex-patterns "CTTACGGTAA" "TTACCGTAAG" "GCAAGGTGAA" "TTCACCTTGC" "GGGCATATGG" "CCATATGCCC" "TCTCTGCCAT" "ATGGCAGAGA" "AGGAGTAAGT" "ACTTACTCCT" "AGGAGTAAGC" "GCTTACTCCT" "ATACATAATC" "GATTATGTAT" "TCACTTTGGC" "GCCAAAGTGA" "GCCACTCCCA" "TGGGAGTGGC" "TCCTGTTCCG" "CGGAACAGGA" "GGCTTACCAT" "ATGGTAAGCC" "GAAGCATTTA" "TAAATGCTTC" \
      --regex-names "CMV_enhancer" "CMV_enhancer_rev" "EX1" "EX1_rev" "IN1" "IN1_rev" "EX2_3ss" "EX2_3ss_rev" "EX2_SMN2_5ss" "EX2_SMN2_5ss_rev" "EX2_ELP1_ris_5ss" "EX2_ELP1_ris_5ss_rev" "IN2" "IN2_rev" "EX3" "EX3_rev" "polyA" "polyA_rev" "ori" "ori_rev" "ampR" "ampR_rev" "ampR_promoter" "ampR_promoter_rev" \
      --max-regex-length 501 \
      --total-chunks 8 \
      --output-dir ./output/parse_regions_v2\
      --count-mem 100G \
      --count-time 1:00:00 \
      --count-cpus 16 \
      --mem 100G \
      --time 2:00:00 \
      --cpus 16 \
      --partition cpuq \
      --qos bio_ai \
      --merge \
      --script-dir /grid/kinney/data/desmara/pacbio_regex_parser/bin