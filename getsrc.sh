#!/bin/bash

set -eu

# download src name
download() {
  src="$1"
  shift

  if [ $# -ge 1 ]; then
    name="$1"
  else
    name="${src##*/}"
  fi

  dest="src/$name"

  if [ -n "${ALWAYS-}" ] || ! [ -f "$dest" ]; then
    echo "Downloading $src to $dest"
    curl -sSL "$src" > "$dest"
  fi
}

mkdir -p src

# download https://github.com/Gaius-Augustus/BRAKER/archive/v2.1.5.tar.gz braker-v2.1.5.tar.gz
download https://github.com/Gaius-Augustus/BRAKER/archive/v2.1.6.tar.gz braker-v2.1.6.tar.gz
# download https://github.com/Gaius-Augustus/Augustus/releases/download/v3.3.3/augustus-3.3.3.tar.gz
download https://github.com/Gaius-Augustus/Augustus/releases/download/v3.5.0/augustus-3.5.0.tar.gz
download https://github.com/pezmaster31/bamtools/archive/v2.5.1.tar.gz bamtools-v2.5.1.tar.gz
download https://github.com/samtools/htslib/archive/1.10.2.tar.gz htslib-1.10.2.tar.gz
download https://github.com/samtools/bcftools/archive/1.10.2.tar.gz bcftools-1.10.2.tar.gz
download https://github.com/samtools/samtools/archive/1.10.tar.gz samtools-1.10.tar.gz
download https://github.com/bbuchfink/diamond/releases/download/v0.9.30/diamond-linux64.tar.gz diamond-0.9.30.tar.gz
