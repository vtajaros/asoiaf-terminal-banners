#!/bin/bash
# generate_banners.sh
# Reads data/houses.json, finds matching images in banners/, and generates ANSI text files in out/

set -e

# ANSI escape codes for formatting
BOLD="\033[1m"
ITALIC="\033[3m"
RESET="\033[0m"

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Please install it using: sudo pacman -S jq"
    exit 1
fi

if ! command -v chafa &> /dev/null; then
    echo "Error: chafa is required but not installed."
    echo "Please install it using: sudo pacman -S chafa"
    exit 1
fi

LOGFILE="scripts/generate_banners.log"
> "$LOGFILE"

# Make output dir
mkdir -p out

total=0
success=0
failures=0

echo "Starting batch conversion..."

while read -r row; do
    house=$(echo "$row" | jq -r '.house')
    words=$(echo "$row" | jq -r '.words')
    
    # Normalize slug
    # - lowercase
    # - replace spaces with underscores
    slug=$(echo "$house" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    
    # Locate matching source file in banners/ directory
    # Most are 375px-House_<Name>.svg.webp
    # Exceptions: 405px-, .svg.png
    
    src_file=""
    
    # Handle known exceptions first
    if [[ "$slug" == "goodbrother" ]]; then
        src_file="banners/375px-House_Goodbrother.svg.png"
    elif [[ "$slug" == "dondarrion" ]]; then
        src_file="banners/405px-House_Dondarrion.svg.webp"
    elif [[ "$slug" == "seaworth" ]]; then
        src_file="banners/405px-House_Seaworth.svg.webp"
    elif [[ "$slug" == "baelish" ]]; then
        src_file="banners/375px-House_Baelish_of_Harrenhal.svg.webp"
    elif [[ "$slug" == "farwynd" ]]; then
        src_file="banners/375px-House_Farwynd_of_the_Lonely_Light.svg.webp"
    else
        # Standard format
        # E.g., House_Bar_Emmon -> Bar_Emmon
        name_camel=$(echo "$house" | sed -e 's/ /\w/g' | tr ' ' '_')
        # Actually it's easier to just match by slug, we can search the directory
        # The original filenames have mixed casing, let's just find it case-insensitively or exactly.
        # Since we mapped them manually in Phase 1, we can do a reverse lookup or simple glob.
    fi
    
    # Better logic: find the file that contains the house name, or specifically constructed
    # Wait, simple globbing with grep is safest
    if [[ -z "$src_file" ]]; then
        # Try exact construction based on original names
        # Most are 375px-House_Name.svg.webp where Name is exactly the house name with spaces -> underscores
        name_part=$(echo "$house" | tr ' ' '_')
        candidate="banners/375px-House_${name_part}.svg.webp"
        if [[ -f "$candidate" ]]; then
            src_file="$candidate"
        else
            # Try to find by slug via listing
            for f in banners/*; do
                f_slug=$(basename "$f" | sed -E 's/^[0-9]+px-House_//i' | sed -E 's/\.(svg\.)?(webp|png)$//i' | tr '[:upper:]' '[:lower:]')
                if [[ "$f_slug" == "$slug" ]]; then
                    src_file="$f"
                    break
                fi
            done
        fi
    fi
    
    total=$((total + 1))
    
    if [[ -n "$src_file" && -f "$src_file" ]]; then
        out_file="out/${slug}.txt"
        
        # Run chafa without --fg-only to keep sigil quality
        chafa --format symbols --size 25x13 "$src_file" > "$out_file"
        
        # Append styled text below
        echo -e "${BOLD}House ${house}${RESET}" >> "$out_file"
        echo -e "${ITALIC}\"${words}\"${RESET}" >> "$out_file"
        
        success=$((success + 1))
    else
        echo "Missing source file for house: $house (slug: $slug)" | tee -a "$LOGFILE"
        failures=$((failures + 1))
    fi

done < <(jq -c '.[]' data/houses.json)

# Check for unaccounted files in banners/
for f in banners/*; do
    if [[ -f "$f" ]]; then
        f_slug=$(basename "$f" | sed -E 's/^[0-9]+px-House_//i' | sed -E 's/\.(svg\.)?(webp|png)$//i' | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
        # Skip known excluded file
        if [[ "$(basename "$f")" == "375px-WylCoA.webp" ]]; then
            continue
        fi
        
        # Check if this slug exists in the JSON
        if ! jq -e --arg s "$f_slug" '.[] | select((.house | ascii_downcase | sub(" "; "_"; "g")) == $s or $s == "baelish_of_harrenhal" or $s == "farwynd_of_the_lonely_light")' data/houses.json > /dev/null; then
             # Try simpler check
             found=0
             for h in $(jq -r '.house' data/houses.json | tr '[:upper:]' '[:lower:]' | tr ' ' '_'); do
                 if [[ "$h" == "$f_slug" || ("$h" == "baelish" && "$f_slug" == "baelish_of_harrenhal") || ("$h" == "farwynd" && "$f_slug" == "farwynd_of_the_lonely_light") ]]; then
                     found=1
                     break
                 fi
             done
             if [[ $found -eq 0 ]]; then
                 echo "Warning: Source file not matched to any manifest entry: $f" | tee -a "$LOGFILE"
             fi
        fi
    fi
done

echo ""
echo "=== Batch Summary ==="
echo "Total manifest entries processed : $total"
echo "Successfully generated           : $success"
echo "Missing/Failed                   : $failures"
echo "====================="
if [[ -s "$LOGFILE" ]]; then
    echo "Please review $LOGFILE for details on mismatches or missing files."
else
    echo "No errors logged."
fi
