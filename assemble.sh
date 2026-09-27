#!/usr/bin/env bash
# Download Gemma 4 26B A4B (QAT Q4_0 GGUF) from this repo's release, check every part and the
# whole file against SHA256SUMS, and join them. Resumes after a dropped connection.
# Usage: ./assemble.sh [output folder, default .]
set -euo pipefail
TAG=gemma-4-26b-a4b-qat-q4_0-v1
BASE="https://github.com/jvoltci/xhimalaya/releases/download/$TAG"
OUT="${1:-.}"
mkdir -p "$OUT" && cd "$OUT"
curl -fsSL -o SHA256SUMS "$BASE/SHA256SUMS"
grep '\.part-' SHA256SUMS | while read -r sum part; do
  if [ -f "$part" ] && [ "$(shasum -a 256 "$part" | cut -d' ' -f1)" = "$sum" ]; then continue; fi
  for try in $(seq 1 50); do
    curl -fL -C - --retry 5 -o "$part" "$BASE/$part" && break || sleep 5
  done
  [ "$(shasum -a 256 "$part" | cut -d' ' -f1)" = "$sum" ] || { echo "bad hash: $part, delete it and run again"; exit 1; }
done
cat gemma-4-26B_q4_0-it.gguf.part-* > gemma-4-26B_q4_0-it.gguf
grep -v '\.part-' SHA256SUMS | shasum -a 256 -c -
rm gemma-4-26B_q4_0-it.gguf.part-*
echo "ready: $(pwd)/gemma-4-26B_q4_0-it.gguf"
