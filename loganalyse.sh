#!/bin/bash
# check if file name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 LOGFILE" >&2
    exit 1
fi 
# check if the log file was provided and if it exist or  it's readable
if [ ! -f "$LOGFILE" ] || [ ! -r "$LOGFILE" ]; then
    echo "Error: file '$LOGFILE' is missing or unreadable" >&2
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
eval $(awk '{
    class = substr($9, 1, 1)
    if (class ~ /[2345]/) count[class]++
}
END {
    printf("status_2xx=%d\nstatus_3xx=%d\nstatus_4xx=%d\nstatus_5xx=%d\n", 
        count["2"], count["3"], count["4"], count["5"])
}' "$LOGFILE")

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

5 top pages
    awk '{print $7}' "$LOGFILE" | sort | uniq -c | sort -nr | head -n 5
    echo "5 top pages"
while read -r count page; do
    printf "  %5d  %s\n" "$count" "$page"
done <<< "$top_pages"
5 top ip address
    awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -rn | head -n 5
while read -r count ip; do
    printf "  %5d  %s\n" "$count" "$ip"
done <<< "$top_ips"
Top 5 Most Frequent 404 Pages:"
    echo "Count | Page URL"
    awk '$9 == 404 {print $7}' "$LOGFILE" | sort | uniq -c | sort -rn | head