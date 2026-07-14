#!/bin/bash
# sync_data.sh
# Converts source.txt (CSV) -> data/houses.json
# Run this whenever source.txt is updated before regenerating banners.

set -e

SRC="source.txt"
OUT="data/houses.json"

if [[ ! -f "$SRC" ]]; then
    echo "Error: $SRC not found. Run from the repo root."
    exit 1
fi

mkdir -p data

echo "[" > "$OUT"

first=true
while IFS=',' read -r house region words source_val tier || [[ -n "$house" ]]; do
    # Skip header line
    [[ "$house" == "HOUSE" ]] && continue
    # Skip blank lines
    [[ -z "$house" ]] && continue

    # Strip trailing carriage returns (Windows line endings)
    house="${house%$'\r'}"
    region="${region%$'\r'}"
    words="${words%$'\r'}"
    source_val="${source_val%$'\r'}"
    tier="${tier%$'\r'}"
    [[ -z "$tier" ]] && tier="minor"

    # Escape any double quotes in words for valid JSON
    words="${words//\"/\\\"}"

    if [[ "$first" == true ]]; then
        first=false
    else
        echo "," >> "$OUT"
    fi

    printf '  {"house": "%s", "region": "%s", "words": "%s", "source": "%s", "tier": "%s"}' \
        "$house" "$region" "$words" "$source_val" "$tier" >> "$OUT"

done < "$SRC"

echo "" >> "$OUT"
echo "]" >> "$OUT"

count=$(grep -c '"house"' "$OUT")
echo "Synced $count houses from $SRC -> $OUT"
