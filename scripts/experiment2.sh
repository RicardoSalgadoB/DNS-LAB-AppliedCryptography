#!/usr/bin/env bash
# Usage: ./domain-queries.sh [output_dir]     (default: ./results)
# FLUSH=0 ./domain-queries.sh out             -> keep recursive1's cache between queries

OUT="${1:-./results}"
mkdir -p "$OUT" && OUT="$(cd "$OUT" && pwd)"
OUTPUT_FILE="$OUT/experiment2_results.txt"

DOMAINS=("gob.mx" "unam.mx")
RECORDS=("SOA" "NS" "A" "AAAA" "DNSKEY" "RRSIG" "DS" "NSEC" "NSEC3")
LOCAL_RESOLVER="172.30.0.101"

: > "$OUTPUT_FILE"

start_capture() {  # $1 = container whose network to sniff, $2 = pcap name
  docker rm -f "cap-$1" >/dev/null 2>&1
  docker run -d --rm --name "cap-$1" --net "container:$1" -v "$OUT":/out \
    nicolaka/netshoot tcpdump -U -i eth0 -w "/out/$2" port 53 >/dev/null
}
stop_capture() { docker stop "cap-$1" >/dev/null 2>&1; }

run_queries() {
  local label="$1" server="$2"
  {
    echo "========================================"
    echo "$label"
    echo "========================================"
    for record in "${RECORDS[@]}"; do
      echo "--- Records ${record} ---"
      for domain in "${DOMAINS[@]}"; do
        # Flush only for the local resolver, so each query shows the full chain
        if [ "$server" = "$LOCAL_RESOLVER" ] && [ "${FLUSH:-1}" = "1" ]; then
          docker exec recursive1 rndc flush
        fi
        echo "\$ dig @$server $domain $record    ($(date '+%F %T'))"
        docker exec client dig "@$server" "$domain" "$record" +time=10 +tries=1
        echo
        sleep 1
      done
    done
  } | tee -a "$OUTPUT_FILE"
}

# Client-side capture: sees client<->recursive1 and client<->8.8.8.8
# Recursive-side capture: sees recursive1<->root/TLD/authoritative servers
start_capture client     experiment2_client.pcap
start_capture recursive1 experiment2_recursive.pcap
sleep 3   # let tcpdump come up before sending queries

run_queries "8.8.8.8 server"          "8.8.8.8"
run_queries "Local recursive server"  "$LOCAL_RESOLVER"

sleep 2
stop_capture client
stop_capture recursive1

echo
echo "Done! Files saved in: $OUT"
ls -l "$OUT"