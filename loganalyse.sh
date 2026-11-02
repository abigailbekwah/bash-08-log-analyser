#!/bin/bash
# check if file name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 LOGFILE" >&2
    exit 1
fi 
# check if the log file was provided and if it exist or  it's readable
if [ ! -f "$LOGFILE" ] || [ ! -r "$LOGFILE" ]; then
    echo "Error: file $LOGFILE is missing or unreadable" >&2
    exit 1
fi 
    LOGFILE="$1"

if [ ! -s "$LOGFILE" ]; then
    echo "========================================"
    echo "         LOG ANALYSIS REPORT            "
    echo "========================================"
    echo "No data available in log file: '$LOGFILE'"
    echo "========================================"
    exit 0  
fi

print_header() {
    echo "========================================"
    echo "         LOG ANALYSIS REPORT            "
    echo "========================================"
}

calculate_bandwidth() {
    local total_bytes
    local total_mb

total_bytes=$(awk '{sum += $10} END {print sum}' "$LOGFILE")
total_mb=$(awk -v bytes="${total_bytes:-0}" 'BEGIN {printf "%.1f", bytes / (1024 * 1024)}')
 
    echo "Total Data Sent:     ${total_mb} MB"
}
calculate_traffic_summary() {
    local total_requests
    local unique_ips

    total_requests=$(wc -l < "$LOGFILE")
    unique_ips=$(awk '{print $1}' "$LOGFILE" | sort | uniq | wc -l)
    echo "Total Requests:  $total_requests"
    echo "Unique IP Addresses: $unique_ips"
}

calculate_status_counts() {
    local status_2xx status_3xx status_4xx status_5xx
    status_2xx=$(awk '$9 ~ /^2/ {print $9}' "$LOGFILE" | wc -l)
    status_3xx=$(awk '$9 ~ /^3/ {print $9}' "$LOGFILE" | wc -l)
    status_4xx=$(awk '$9 ~ /^4/ {print $9}' "$LOGFILE" | wc -l)
    status_5xx=$(awk '$9 ~ /^5/ {print $9}' "$LOGFILE" | wc -l)

}
echo "----------------------------------------"
echo "HTTP Status Responses:"
echo "  2xx (Success):     $status_2xx"
echo "  3xx (Redirection): $status_3xx"
echo "  4xx (Client Error):$status_4xx"
echo "  5xx (Server Error):$status_5xx"
echo "========================================"

print_top_pages() {
    echo "----------------------------------------"
    echo "Top 5 Most Requested Pages:"
    echo "Count | Page URL"
    awk '{print $7}' "$LOGFILE" | sort | uniq -c | sort -rn | head -n 5
}

print_top_(){
echo "----------------------------------------"
    echo "Top 5 Most Frequent IP Addresses:"
    echo "Count | IP Address"
    awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -rn | head -n 5
}

print_top_broken_links() {
    echo "----------------------------------------"
    echo "Top 5 Most Frequent 404 Pages:"
    echo "Count | Page URL"
    awk '$9 == 404 {print $7}' "$LOGFILE" | sort | uniq -c | sort -rn | head -n 5
}

print_footer() {
    echo "========================================"
}

print_header
calculate_traffic_summary
calculate_bandwidth
calculate_status_counts
print_top_ips
print_top_pages
print_top_broken_links
print_footer 