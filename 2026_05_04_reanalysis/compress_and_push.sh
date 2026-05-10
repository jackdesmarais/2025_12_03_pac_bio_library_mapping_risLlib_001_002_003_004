#!/bin/bash
#SBATCH --job-name=xz_compress_push
#SBATCH --output=compress_and_push_%j.log
#SBATCH --error=compress_and_push_%j.log
#SBATCH --time=4:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4

set -euo pipefail

CSV_DIR="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004/2026_05_04_reanalysis/parsing_v2/2026_05_08_filtered_BC_VR_table"
REPO_ROOT="/grid/kinney/data/desmara/2025_12_03_pac_bio_library_mapping_risLlib_001_002_003_004"
MAX_BYTES=$((100 * 1024 * 1024))  # 100 MB in bytes

echo "=== Starting compression job at $(date) ==="
echo "CSV directory: ${CSV_DIR}"

added_files=()
skipped_files=()

for csv_file in "${CSV_DIR}"*.csv; do
    [ -f "${csv_file}" ] || continue

    xz_file="${csv_file}.xz"
    basename_csv=$(basename "${csv_file}")
    basename_xz=$(basename "${xz_file}")

    echo ""
    echo "--- Processing: ${basename_csv} ---"

    # Skip if already compressed
    if [ -f "${xz_file}" ]; then
        echo "  Already compressed, skipping xz step: ${basename_xz}"
    else
        echo "  Compressing with xz -T4 ($(du -sh "${csv_file}" | cut -f1) -> ?) ..."
        xz -v -k -T4 "${csv_file}"
        echo "  Compression done."
    fi

    # Check compressed file size
    compressed_size=$(stat -c%s "${xz_file}")
    compressed_mb=$(echo "scale=1; ${compressed_size} / 1048576" | bc)
    echo "  Compressed size: ${compressed_mb} MB"

    if [ "${compressed_size}" -lt "${MAX_BYTES}" ]; then
        echo "  Under 100 MB — staging for git add."
        git -C "${REPO_ROOT}" add "${xz_file}"
        added_files+=("${basename_xz}")
    else
        echo "  WARNING: ${compressed_mb} MB >= 100 MB — skipping git add (GitHub limit)."
        skipped_files+=("${basename_xz} (${compressed_mb} MB)")
    fi
done

echo ""
echo "=== Summary ==="
echo "Files added to git (${#added_files[@]}):"
for f in "${added_files[@]+"${added_files[@]}"}"; do
    echo "  + ${f}"
done

echo "Files skipped — too large (${#skipped_files[@]}):"
for f in "${skipped_files[@]+"${skipped_files[@]}"}"; do
    echo "  - ${f}"
done

if [ "${#added_files[@]}" -gt 0 ]; then
    echo ""
    echo "Committing and pushing..."
    git -C "${REPO_ROOT}" commit -m "Add xz-compressed CSV files from parsing step"
    git -C "${REPO_ROOT}" push origin
    echo "Push complete at $(date)."
else
    echo ""
    echo "No files were added — nothing to commit."
fi

echo ""
echo "=== Job finished at $(date) ==="
