#!/usr/bin/env bash
RESOLVER=172.30.0.100
OUT=results/experiment3_recursive1
mkdir -p "$OUT"
: > "$OUT/experiment3_results.txt"

QUERIES=(
  "www.beta.signed A"
  "www.gamma.signed A"
  "beta.signed DNSKEY"
  "beta.signed DS"
  "gamma.signed DS"
  "signed DNSKEY"
  ". DNSKEY"
  "noexiste.beta.signed A"
)

for q in "${QUERIES[@]}"; do
  docker exec recursive1 rndc flush
  echo "===== dig @$RESOLVER $q +dnssec =====" >> "$OUT/experiment3_results.txt"
  docker exec client dig @"$RESOLVER" $q +dnssec >> "$OUT/experiment3_results.txt"
done
