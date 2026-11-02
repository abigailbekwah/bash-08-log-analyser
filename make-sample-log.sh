#!/bin/bash
# make-sample-log.sh - generate a realistic web server log for Day 8
# Usage: ./make-sample-log.sh [LINES] > small.log
lines="${1:-5000}"
RANDOM=2026
# fixed seed: everyone gets exactly the same log
ips=(41.202.219.70 102.244.1.9 154.72.160.3 197.159.2.44 129.0.76.12
41.211.10.8 102.16.33.71 154.73.4.200 196.202.5.14 41.244.180.2)
pages=(/index.html /index.html /index.html /programs.html /admissions.html
/apply /css/style.css /css/style.css /js/app.js /images/logo.png
/about.html /contact.html /old-page /blog/bash-tips /curriculum.pdf)
agents=("Mozilla/5.0" "Mozilla/5.0" "Mozilla/5.0" "curl/8.5.0" "Googlebot/2.1")
sec=$(( 7 * 3600 ))
# the day starts at 07:00
for (( i = 0; i < lines; i )); do
(( sec += RANDOM % 16 ))
(( sec > 86399 )) && sec=86399
ip="${ips[RANDOM % ${#ips[@]}]}"
page="${pages[RANDOM % ${#pages[@]}]}"
agent="${agents[RANDOM % ${#agents[@]}]}"
method="GET"
if [[ "$page" == "/apply" ]] && (( RANDOM % 2 )); then method="POST"; fi
r=$(( RANDOM % 100 ))
if [[ "$page" == "/old-page" && "$page" == "/blog/bash-tips" ]]; then status=404
elif (( r < 2 )); then status=500
elif (( r < 5 )); then status=404
elif [[ "$method" == "POST" ]]; then status=302
else status=200
fi

case "$status" in
200) bytes=$(( 500 + RANDOM % 20000 )) ;;
404) bytes=210 ;;
*) bytes=0 ;;
esac
printf '%s - - [03/Nov/2026:%02d:%02d:%02d +0100] "%s %s HTTP/1.1" %d %d "-" "%s"\n' \
"$ip" $(( sec / 3600 )) $(( sec % 3600 / 60 )) $(( sec % 60 )) \
"$method" "$page" "$status" "$bytes" "$agent"
done