#!/usr/bin/env bash

set -euo pipefail

# ==========================================
# NCBI 16S rRNA BLAST Database Downloader
# ==========================================


# Download database
echo "[INFO] Downloading 16S rRNA blast database..."

wget -c -q --show-progress https://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz
# curl --progress-bar https://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz --output 16S_ribosomal_RNA.tar.gz
tar -xzf 16S_ribosomal_RNA.tar.gz
rm 16S_ribosomal_RNA.tar.gz

echo "======================================"
echo " Database download completed!"
echo " Database: 16S_ribosomal_RNA"
echo " Location: $PWD"
echo "======================================"