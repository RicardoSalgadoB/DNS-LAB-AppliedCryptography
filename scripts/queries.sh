#!/usr/bin/env bash
# Usage: ./queries.sh [output_dir]     (default: ./results)
# FLUSH=0 ./queries.sh out             -> keep recursive1's cache between queries

OUT="${1:-./results}"
mkdir -p "$OUT" && OUT="$(cd "$OUT" && pwd)"
FILE="$OUT/dig-results.txt"

QUERIES=(
  ". SOA"
  ". NS"
  "ns.root A"
  "unsigned SOA"
  "unsigned NS"
  "ns.unsigned A"
  "alpha.unsigned SOA"
  "alpha.unsigned NS"
  "ns.alpha.unsigned A"
  "www.alpha.unsigned A"
)

: > "$FILE"
for q in "${QUERIES[@]}"; do
  # Flush by default so every query shows the full chain in Wireshark
  [ "${FLUSH:-1}" = "1" ] && docker exec recursive1 rndc flush
  {
    echo "=================================================="
    echo "\$ dig @172.30.0.100 $q        ($(date '+%F %T'))"
    echo "=================================================="
    docker exec client dig @172.30.0.100 $q    # $q unquoted on purpose: "name TYPE" must split
    echo
  } | tee -a "$FILE"
  sleep 1
done

echo "Results saved to: $FILE"