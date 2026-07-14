#!/bin/bash
# generate_banners.sh
# Syncs source.txt -> data/houses.json, then generates ANSI text files in out/
# source.txt is the single source of truth for house data.

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

# Sync source.txt -> houses.json before generating
echo "Syncing source.txt -> data/houses.json..."
bash "$(dirname "$0")/sync_data.sh"

LOGFILE="scripts/generate_banners.log"
true > "$LOGFILE"

# Make output dir
mkdir -p out
POOLFILE="out/pool.txt"
true > "$POOLFILE"

total=0
success=0
failures=0

echo "Starting batch conversion..."

while read -r row; do
    house=$(echo "$row" | jq -r '.house')
    words=$(echo "$row" | jq -r '.words')
    source_val=$(echo "$row" | jq -r '.source')
    tier_val=$(echo "$row" | jq -r '.tier // "minor"')
    
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
    elif [[ "$slug" == "vyrwel" ]]; then
        src_file="banners/375px-House_Vyrwel_2.svg.webp"
    elif [[ "$slug" == "vance_of_wayfarer's_rest" ]]; then
        src_file="banners/375px-House_Vance_of_Wayfarer's_Rest.svg.webp"
    elif [[ "$slug" == "stonehouse" ]]; then
        src_file="banners/375px-House_Stonehouse_2.svg.webp"
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
        
        # Calculate centering padding relative to banner width (25 columns)
        target_width=25

        name_str="House ${house}"
        name_len=${#name_str}
        name_pad=$(( (target_width - name_len) / 2 ))
        (( name_pad < 0 )) && name_pad=0
        name_indent=$(printf '%*s' "$name_pad" "")

        if [[ "$source_val" != "canon" ]]; then
            words_str="\"${words}\" *"
        else
            words_str="\"${words}\""
        fi
        words_len=${#words_str}
        words_pad=$(( (target_width - words_len) / 2 ))
        (( words_pad < 0 )) && words_pad=0
        words_indent=$(printf '%*s' "$words_pad" "")

        # Append styled centered text below
        echo -e "${name_indent}${BOLD}${name_str}${RESET}" >> "$out_file"
        echo -e "${words_indent}${ITALIC}${words_str}${RESET}" >> "$out_file"
        
        # Add to weighted random pool based on tier
        case "$tier_val" in
            great) weight=5 ;;
            important) weight=3 ;;
            *) weight=1 ;;
        esac
        for (( w=0; w<weight; w++ )); do
            echo "${slug}.txt" >> "$POOLFILE"
        done
        
        success=$((success + 1))
    else
        echo "Missing source file for house: $house (slug: $slug)" | tee -a "$LOGFILE"
        failures=$((failures + 1))
    fi

done < <(jq -c '.[]' data/houses.json)

# Check for unaccounted files in banners/
for f in banners/*; do
    [[ -f "$f" ]] || continue
    bname=$(basename "$f")

    # Skip known excluded files (no manifest entry)
    [[ "$bname" == "375px-WylCoA.webp" ]] && continue

    # Skip files whose names don't match the standard slug directly
    # but are accounted for via the exceptions list above
    case "$bname" in
        375px-House_Baelish_of_Harrenhal.svg.webp) continue ;;
        375px-House_Farwynd_of_the_Lonely_Light.svg.webp) continue ;;
        375px-House_Vyrwel_2.svg.webp) continue ;;
        "375px-House_Vance_of_Wayfarer's_Rest.svg.webp") continue ;;
        375px-House_Stonehouse_2.svg.webp) continue ;;
    esac

    f_slug=$(echo "$bname" | sed -E 's/^[0-9]+px-House_//i' | sed -E 's/\.(svg\.)?(webp|png)$//i' | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

    found=0
    while IFS=',' read -r h _rest || [[ -n "$h" ]]; do
        [[ "$h" == "HOUSE" || -z "$h" ]] && continue
        h_slug=$(echo "$h" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
        if [[ "$h_slug" == "$f_slug" ]]; then
            found=1
            break
        fi
    done < source.txt

    if [[ $found -eq 0 ]]; then
        echo "Warning: Source file not matched to any manifest entry: $f" | tee -a "$LOGFILE"
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
