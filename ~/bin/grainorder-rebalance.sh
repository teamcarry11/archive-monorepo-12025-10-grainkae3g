#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║                    GRAINORDER REBALANCE (BASH)                           ║
# ║          temporary bash implementation until Steel is installed          ║
# ║                                                                          ║
# ║  rebalances grainorders in a directory: newest=smallest                  ║
# ╚══════════════════════════════════════════════════════════════════════════╝

DIR="$1"

if [ -z "$DIR" ]; then
    echo "❌ Usage: $0 <directory>"
    exit 1
fi

cd "$DIR" || exit 1

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║  GRAINORDER REBALANCE 🔄                       ║"
echo "╚════════════════════════════════════════════════╝"
echo ""
echo "directory: $DIR"
echo ""

# Find all grainorder files and extract timestamp for sorting
declare -a files
declare -a timestamps

for file in xzv*.md; do
    [ -e "$file" ] || continue
    
    # Extract timestamp: xzvbdg-12025-10-28--1300-pdt--readme.md → 1202510281300
    if [[ $file =~ ^[a-z]{6}-([0-9]{5})-([0-9]{2})-([0-9]{2})--([0-9]{4})-[a-z]{3,4}-- ]]; then
        year="${BASH_REMATCH[1]}"
        month="${BASH_REMATCH[2]}"
        day="${BASH_REMATCH[3]}"
        time="${BASH_REMATCH[4]}"
        timestamp="${year}${month}${day}${time}"
        
        files+=("$file")
        timestamps+=("$timestamp")
    fi
done

if [ ${#files[@]} -eq 0 ]; then
    echo "❌ no grainorder files found"
    exit 1
fi

echo "found ${#files[@]} grainorder files"
echo ""

# Sort files by timestamp (newest first)
# Create array of indices
indices=()
for i in "${!timestamps[@]}"; do
    indices+=("$i")
done

# Bubble sort by timestamp (descending)
for ((i = 0; i < ${#indices[@]}; i++)); do
    for ((j = i + 1; j < ${#indices[@]}; j++)); do
        idx_i=${indices[$i]}
        idx_j=${indices[$j]}
        if [ "${timestamps[$idx_i]}" -lt "${timestamps[$idx_j]}" ]; then
            # Swap
            temp=${indices[$i]}
            indices[$i]=${indices[$j]}
            indices[$j]=$temp
        fi
    done
done

# Generate new grainorders (using grainorder alphabet)
alphabet="xbdghjklmnsvz"
function next_grainorder() {
    local current="$1"
    local result=""
    
    # For simplicity, use a simple sequence
    # This is a simplified version - full implementation would check for no repeating chars
    case "$current" in
        "xbdghj") echo "xbdghk" ;;
        "xbdghk") echo "xbdghl" ;;
        "xbdghl") echo "xbdghm" ;;
        "xbdghm") echo "xbdghn" ;;
        "xbdghn") echo "xbdghs" ;;
        "xbdghs") echo "xbdghv" ;;
        "xbdghv") echo "xbdghz" ;;
        "xbdghz") echo "xbdgjk" ;;
        "xbdgjk") echo "xbdgjl" ;;
        "xbdgjl") echo "xbdgjm" ;;
        "xbdgjm") echo "xbdgjn" ;;
        "xbdgjn") echo "xbdgjs" ;;
        "xbdgjs") echo "xbdgjv" ;;
        "xbdgjv") echo "xbdgjz" ;;
        "xbdgjz") echo "xbdgkl" ;;
        "xbdgkl") echo "xbdgkm" ;;
        "xbdgkm") echo "xbdgkn" ;;
        *) echo "xbdgks" ;;
    esac
}

# Generate grainorder sequence
new_grainorders=()
current="xbdghj"
for ((i = 0; i < ${#files[@]}; i++)); do
    new_grainorders+=("$current")
    current=$(next_grainorder "$current")
done

# Show rebalancing plan
echo "rebalancing plan (newest → oldest):"
echo ""
printf "  %-20s  %-10s → %-10s  %s\n" "TIMESTAMP" "OLD" "NEW" "FILE"
echo "  ────────────────────────────────────────────────────────────────────"

for ((i = 0; i < ${#indices[@]}; i++)); do
    idx=${indices[$i]}
    file="${files[$idx]}"
    timestamp="${timestamps[$idx]}"
    
    # Extract old grainorder
    old_grainorder="${file:0:6}"
    
    # Get new grainorder
    new_grainorder="${new_grainorders[$i]}"
    
    # Extract rest of filename
    rest="${file:7}"
    
    # Format timestamp for display
    ts_display=$(echo "$timestamp" | sed 's/\([0-9]\{5\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{4\}\)/\2-\3 \4/')
    
    printf "  %-20s  %-10s → %-10s  %s\n" "$ts_display" "$old_grainorder" "$new_grainorder" "${rest:0:30}..."
done

echo ""
echo "⚠️  this will rename ${#files[@]} files! continue? (y/n)"
read -r response

if [ "$response" != "y" ]; then
    echo ""
    echo "❌ rebalancing cancelled"
    echo ""
    exit 0
fi

echo ""
echo "🔄 renaming files..."
echo ""

# Perform renames (in two passes to avoid conflicts)
# First pass: rename to temp names
for ((i = 0; i < ${#indices[@]}; i++)); do
    idx=${indices[$i]}
    file="${files[$idx]}"
    echo "  → ${file} (temp)"
    mv "$file" "TEMP_${i}_${file}"
done

# Second pass: rename to final names
for ((i = 0; i < ${#indices[@]}; i++)); do
    idx=${indices[$i]}
    file="${files[$idx]}"
    new_grainorder="${new_grainorders[$i]}"
    rest="${file:7}"
    new_file="${new_grainorder}-${rest}"
    
    echo "  → ${new_file}"
    mv "TEMP_${i}_${file}" "$new_file"
done

echo ""
echo "✅ rebalancing complete!"
echo "🌾 now == next + 1"
echo ""


