#!/usr/bin/env bash
# Usage: ./two-terms-kali.sh [output_dir]
DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "${1:-$DIR/results}"
OUT="$(cd "${1:-$DIR/results}" && pwd)"

xfce4-terminal \
  --tab -T "capture" -e "bash -c 'sudo tcpdump -U -i br-dns -w \"$OUT/dns.pcap\" port 53; exec bash'" \
  --tab -T "queries" -e "bash -c 'sleep 4; \"$DIR/queries.sh\" \"$OUT\"; echo; echo Press Ctrl+C in the capture tab to stop tcpdump; exec bash'"