#!/usr/bin/env python3
"""
Rebalance grainorder codes using updated alphabet: bcfghlmnqsvxz
Removes old characters: d, j, k
Assigns new codes maintaining chronological order (newest = smallest codes)
"""

import os
import re
import subprocess
import sys
from pathlib import Path

# Updated alphabet (alphabetical order)
ALPHABET = "bcfghlmnqsvxz"
LENGTH = 6

def char_position(c):
    """Find position of character in alphabet (0-12)"""
    try:
        return ALPHABET.index(c)
    except ValueError:
        return -1

def find_smaller(c, forbidden):
    """Find next SMALLER character than c, not in forbidden string"""
    pos = char_position(c)
    if pos < 0:
        return None
    for i in range(pos - 1, -1, -1):
        candidate = ALPHABET[i]
        if candidate not in forbidden:
            return candidate
    return None

def find_largest(forbidden):
    """Find LARGEST character not in forbidden string"""
    for i in range(len(ALPHABET) - 1, -1, -1):
        candidate = ALPHABET[i]
        if candidate not in forbidden:
            return candidate
    return None

def prev_grainorder(current):
    """
    Get previous (smaller) grainorder code.
    Uses place-value thinking: start at position 1 (rightmost), try to decrement.
    """
    if len(current) != LENGTH:
        return None
    
    # Position 1 = rightmost (index 5), position 6 = leftmost (index 0)
    def try_position(pos):
        if pos > LENGTH:  # overflow
            return None
        
        # Everything to the left (deeper positions)
        left = current[:LENGTH - pos]
        # Character at this position
        char_here = current[LENGTH - pos]
        
        # Try to find smaller unused char
        smaller = find_smaller(char_here, left)
        
        if smaller:
            # Found smaller char! Use it and reset positions to right
            built = left + smaller
            # Reset positions to right (shallower) to largest available
            for p in range(pos - 1, 0, -1):
                largest = find_largest(built)
                if largest:
                    built += largest
                else:
                    break
            return built
        else:
            # No smaller char, carry LEFT (go deeper)
            return try_position(pos + 1)
    
    return try_position(1)

def parse_grainorder_filename(filename):
    """Parse grainorder and timestamp from filename"""
    parts = filename.split('-')
    if len(parts) < 6:
        return None
    
    grainorder = parts[0]
    if len(grainorder) != 6:
        return None
    
    try:
        year = parts[1]
        month = parts[2]
        day = parts[3]
        dash_dash = parts[4]
        time = parts[5]
        tz = parts[6]
        
        if len(year) == 5 and len(month) == 2 and len(day) == 2:
            timestamp = f"{year}-{month}-{day}--{time}-{tz}"
            rest = '-'.join(parts[7:])
            return {
                'grainorder': grainorder,
                'timestamp': timestamp,
                'rest': rest,
                'full_path': filename
            }
    except (IndexError, ValueError):
        pass
    
    return None

def timestamp_to_int(timestamp):
    """Convert timestamp to comparable integer (YYYYMMDDHHMM)
    
    Handles format: YYYY-MM-DD--HHMM-tz
    Example: 12025-10-31--2145-pdt → 1202510312145
    """
    # Split by double dash to separate date and time
    if '--' in timestamp:
        date_part, time_part = timestamp.split('--', 1)
        # Extract time (HHMM) before timezone
        time = time_part.split('-')[0] if '-' in time_part else time_part[:4]
    else:
        # Fallback: try to parse without double dash
        parts = timestamp.split('-')
        if len(parts) < 4:
            return 0
        date_part = '-'.join(parts[:3])
        time = parts[3] if len(parts) > 3 else "0000"
    
    # Parse date part (YYYY-MM-DD)
    date_parts = date_part.split('-')
    if len(date_parts) < 3:
        return 0
    
    year = date_parts[0]
    month = date_parts[1]
    day = date_parts[2]
    
    # Ensure time is 4 digits
    time = time[:4].zfill(4)
    
    try:
        return int(f"{year}{month}{day}{time}")
    except ValueError:
        return 0

def main(directory_path):
    """Rebalance grainorders in directory"""
    print("\n" + "="*60)
    print("  GRAINORDER REBALANCE 🔄")
    print("="*60 + "\n")
    
    print(f"Directory: {directory_path}\n")
    
    expanded_dir = os.path.expanduser(directory_path)
    if not os.path.isdir(expanded_dir):
        print(f"❌ Directory not found: {expanded_dir}")
        return False
    
    # Find ALL .md files (not just xzvs*) to include files like xzvq, etc.
    result = subprocess.run(
        ['find', expanded_dir, '-name', '*.md', '-type', 'f'],
        capture_output=True,
        text=True
    )
    
    files = [f for f in result.stdout.strip().split('\n') if f]
    
    # Parse filenames with grainorder (any 6-char prefix followed by date)
    # Rebalance ALL files to ensure unique codes
    parsed = []
    for filepath in files:
        filename = os.path.basename(filepath)
        p = parse_grainorder_filename(filename)
        if p:
            # Only include if it starts with xzv (grainorder pattern)
            if p['grainorder'].startswith('xzv'):
                p['full_path'] = filepath
                parsed.append(p)
    
    if not parsed:
        print("✓ No grainorder files found")
        return True
    
    print(f"Found {len(parsed)} files to rebalance (ensuring unique codes)\n")
    
    # Sort by timestamp (newest first), then by description for consistency
    # Special handling: for listen-part files, part 3 (newest) → part 2 → part 1 (oldest)
    def sort_key(parsed_file):
        ts_int = timestamp_to_int(parsed_file['timestamp'])
        rest = parsed_file['rest']
        # Extract part number if it's a listen-part file
        import re
        part_match = re.search(r'listen-part-(\d+)', rest)
        if part_match:
            part_num = int(part_match.group(1))
            # With reverse=True, higher values sort first
            # So part 3 (newest) should have highest value → use positive part_num
            return (ts_int, part_num, rest)
        # For other files, use rest as secondary sort
        return (ts_int, rest)
    
    sorted_files = sorted(
        parsed,
        key=sort_key,
        reverse=True
    )
    
    # Generate new grainorders (newest = smallest codes)
    # Strategy: Generate many codes, sort alphabetically, assign smallest to newest
    current_code = "xzvsnm"  # Start from large code
    all_generated_codes = []
    
    # Generate many codes working backwards (more than we need)
    for i in range(len(sorted_files) * 2):
        prev = prev_grainorder(current_code)
        if prev:
            all_generated_codes.append(prev)
            current_code = prev
        else:
            break
    
    # Sort all generated codes alphabetically (smallest first)
    all_generated_codes_sorted = sorted(all_generated_codes)
    
    # Take the smallest codes for our files (newest files get smallest codes)
    new_grainorders = all_generated_codes_sorted[:len(sorted_files)]
    
    # Show rebalancing plan
    print("Rebalancing plan (newest → oldest):")
    print("Strategy: Assign unique codes using alphabet (bcfghlmnqsvxz)")
    print("         Newest files get smallest codes\n")
    
    # Verify assignment: newest files should get smallest codes
    print("\nAssignment verification (newest → oldest):")
    for i, (parsed_file, new_grainorder) in enumerate(zip(sorted_files[:10], new_grainorders[:10])):
        old_grainorder = parsed_file['grainorder']
        timestamp = parsed_file['timestamp']
        rest = parsed_file['rest']
        print(f"  {i+1:2d}. {timestamp}  {old_grainorder} → {new_grainorder}  ({rest[:50]}...)")
    
    if len(sorted_files) > 10:
        print(f"  ... ({len(sorted_files) - 10} more files)")
    
    # Prompt for confirmation
    print("\n⚠️  This will rename files! Continue? (y/n): ", end='')
    response = input().strip().lower()
    
    if response != 'y':
        print("\n❌ Rebalancing cancelled\n")
        return False
    
    print("\n🔄 Renaming files...\n")
    
    # Rename each file
    for parsed_file, new_grainorder in zip(sorted_files, new_grainorders):
        old_path = parsed_file['full_path']
        timestamp = parsed_file['timestamp']
        rest = parsed_file['rest']
        # Clean up rest: remove leading dashes, use single dash separator
        cleaned_rest = rest.lstrip('-')
        if cleaned_rest:
            # Ensure single dash separator (not double dash)
            if not cleaned_rest.startswith('-'):
                cleaned_rest = '-' + cleaned_rest
        else:
            cleaned_rest = ''
        new_filename = f"{new_grainorder}-{timestamp}{cleaned_rest}"
        new_path = os.path.join(os.path.dirname(old_path), new_filename)
        
        print(f"  → {new_filename}")
        os.rename(old_path, new_path)
    
    print("\n✅ Rebalancing complete!")
    print("🌾 now == next + 1\n")
    return True

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python3 rebalance-grainorders.py <directory>")
        sys.exit(1)
    
    main(sys.argv[1])

