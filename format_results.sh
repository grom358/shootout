#!/bin/bash
if [[ -z "CPU" ]]; then
  echo "Error: CPU is not set" >&2
  exit 1
fi
if [[ -z "OS" ]]; then
  echo "Error: OS is not set" >&2
  exit 1
fi

# Read lines from stdin into array
mapfile -t lines < <(sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$')

# Print header text
echo "## Results"
echo
echo "Tested on $CPU"
echo "$OS"
echo
echo "Legend:"
echo "* Time = Total seconds"
echo "* RSS = maximum resident set size in KB"
echo

# Parse fields and collect lengths
max_lang=8  # minimum header width
max_time=4
max_rss=3

rows=()
for line in "${lines[@]}"; do
    read -r _ lang time rss <<<"$line"
    rows+=("$lang|$time|$rss")

    (( ${#lang} > max_lang )) && max_lang=${#lang}
    (( ${#time} > max_time )) && max_time=${#time}
    (( ${#rss} > max_rss )) && max_rss=${#rss}
done

# Print header
printf "| %-*s | %*s | %*s |\n" \
    "$max_lang" "Language" \
    "$max_time" "Time" \
    "$max_rss" "RSS"

# Print separator
printf "| -%s- | -%s: | -%s: |\n" \
    "$(head -c $((max_lang - 2)) < <(yes - | tr '\n' '-'))" \
    "$(head -c $((max_time - 2)) < <(yes - | tr '\n' '-'))" \
    "$(head -c $((max_rss - 2)) < <(yes - | tr '\n' '-'))"

# Print data rows
for entry in "${rows[@]}"; do
    IFS="|" read -r lang time rss <<<"$entry"
    printf "| %-*s | %*s | %*s |\n" \
        "$max_lang" "$lang" \
        "$max_time" "$time" \
        "$max_rss" "$rss"
done
