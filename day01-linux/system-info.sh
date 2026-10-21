#!/usr/bin/env bash

set -u

echo "===== SYSTEM INFORMATION ====="
echo "Hostname: $(hostname)"
echo "OS: $(. /etc/os-release && echo "$PRETTY_NAME")"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "CPU cores: $(nproc)"

echo
echo "===== MEMORY ====="
free -h

echo
echo "===== ROOT FILESYSTEM ====="
df -h /

echo
echo "===== IP ADDRESSES ====="
ip -br addr

echo
echo "===== LOAD AVERAGE ====="
cat /proc/loadavg
