#!/bin/bash
# check if file name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 LOGFILE" >&2
    exit 1
# check if the log file was provided and if it exist or  it's readable
if [ ! -f "$LOGFILE" ] || [ ! -r "$LOGFILE" ]; then
    echo "Erroe: file '$LOGFILE' is missing or unreadable" >&2
    exit 1
fi 
LOGFILE="$1"

# Calculations
total_requests=$(wc -l < "$LOGFILE")
unique_ips=$(awk '{print $1}' "$LOGFILE" | sort | uniq | wc -l)

# Count status codes efficiently using awk matching
status_2xx=$(awk '$9 ~ /^2/ {print $9}' "$LOGFILE" | wc -l)
status_3xx=$(awk '$9 ~ /^3/ {print $9}' "$LOGFILE" | wc -l)
status_4xx=$(awk '$9 ~ /^4/ {print $9}' "$LOGFILE" | wc -l)
status_5xx=$(awk '$9 ~ /^5/ {print $9}' "$LOGFILE" | wc -l)

# Output formatting
echo "========================================"
echo "         LOG ANALYSIS REPORT            "
echo "========================================"
echo "Total Requests:      $total_requests"
echo "Unique IP Addresses: $unique_ips"
echo "----------------------------------------"
echo "HTTP Status Responses:"
echo "  2xx (Success):     $status_2xx"
echo "  3xx (Redirection): $status_3xx"
echo "  4xx (Client Error):$status_4xx"
echo "  5xx (Server Error):$status_5xx"
echo "========================================"