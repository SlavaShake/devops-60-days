#!/usr/bin/env bash

set -u

echo "===== SERVER HEALTH CHECK ====="
echo "Timestamp: $(date --iso-8601=seconds)"
echo

# Disk usage of root filesystem
disk_usage=$(df -P / | awk 'NR == 2 {gsub(/%/, "", $5); print $5}')

if (( disk_usage >= 90 )); then
    echo "[CRITICAL] Root filesystem usage: ${disk_usage}%"
elif (( disk_usage >= 80 )); then
    echo "[WARNING] Root filesystem usage: ${disk_usage}%"
else
    echo "[OK] Root filesystem usage: ${disk_usage}%"
fi

# Memory usage
memory_usage=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2*100}')

if (( memory_usage >= 90 )); then
    echo "[WARNING] Memory usage: ${memory_usage}%"
else
    echo "[OK] Memory usage: ${memory_usage}%"
fi

# Required TCP ports
for port in 22 80 443; do
    if sudo ss -lntH | awk -v p=":$port" '$4 ~ (p "$") {found=1} END {exit !found}'; then
        echo "[INFO] TCP port $port is listening"
    else
        echo "[INFO] TCP port $port is not listening"
    fi
done

# HTTPS connectivity
if curl -fsSI --max-time 5 https://github.com >/dev/null; then
    echo "[OK] HTTPS connectivity works"
else
    echo "[WARNING] HTTPS connectivity check failed"
fi

echo
echo "===== CHECK COMPLETE ====="
