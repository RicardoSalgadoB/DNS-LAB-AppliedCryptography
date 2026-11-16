#!/usr/bin/env bash
# Usage: ./two-panes.sh [output_dir]
DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "${1:-$DIR/results}"
OUT="$(cd "${1:-$DIR/results}" && pwd)"
S=dns

tmux kill-session -t $S 2>/dev/null
tmux new-session -d -s $S -c "$DIR"
tmux send-keys -t $S "docker rm -f dns-capture >/dev/null 2>&1; docker run --rm --name dns-capture --net container:recursive1 -v '$OUT':/out nicolaka/netshoot tcpdump -U -i eth0 -w /out/dns.pcap port 53" C-m
tmux split-window -h -t $S -c "$DIR"
tmux send-keys -t $S "sleep 5; '$DIR/queries.sh' '$OUT'; sleep 2; docker stop dns-capture; ls -l '$OUT'" C-m
tmux attach -t $S