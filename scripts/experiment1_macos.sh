#!/usr/bin/env bash
# Usage: ./two-terms.sh [output_dir]
DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "${1:-$DIR/results}"
OUT="$(cd "${1:-$DIR/results}" && pwd)"

# Window 1: capture at recursive1 (named so window 2 can stop it cleanly)
CMD1="docker rm -f dns-capture >/dev/null 2>&1; docker run --rm --name dns-capture --net container:recursive1 -v '$OUT':/out nicolaka/netshoot tcpdump -U -i eth0 -w /out/dns.pcap port 53"

# Window 2: wait for the capture, run the queries, then stop the capture
CMD2="sleep 5 && '$DIR/queries.sh' '$OUT'; sleep 2; docker stop dns-capture; echo; echo Files in '$OUT':; ls -l '$OUT'"

esc() { local s=${1//\\/\\\\}; printf '%s' "${s//\"/\\\"}"; }

osascript <<EOF
tell application "Terminal"
    activate
    do script "$(esc "$CMD1")"
    do script "$(esc "$CMD2")"
end tell
EOF