# Patent Application 2: Grainorder - Permutation-Based Ordering System

**Title**: "Non-Duplicating Lexicographic Permutation System for Unique Identifiers"  
**Copyright © 3x39** | https://github.com/3x39  
**Inventors**: kae3g (kj3x39, @risc.love)  
**Date**: 2025-10-26

---

## ABSTRACT

A universal ordering system using a constrained alphabet of 13 consonants (xbdghjklmnsvz) to generate exactly 1,235,520 unique 6-character codes without character repetition within individual codes. The system provides deterministic sequential generation, validation, and mapping of arbitrary content to unique, human-readable, pronounceable identifiers. The system ensures lexicographic ordering, enabling alphabetical sorting while maintaining mathematical uniqueness properties. Applications include knowledge management, content addressing, file naming, and database indexing where bounded, sequential, and human-friendly identifiers are required.

---

## BACKGROUND

### Problem Statement

Current identifier systems suffer from:
1. **UUIDs**: 128-bit random (e.g., "550e8400-e29b-41d4-a716-446655440000")
   - Not human-readable
   - Not sequential
   - Cannot memorize or type easily

2. **Auto-incrementing integers**: 1, 2, 3, 4...
   - Reveals scale (competitor intelligence leak)
   - No semantic meaning
   - Collision-prone in distributed systems

3. **Shortened URLs**: Base62/Base64 encoding
   - Can contain vowels (accidental words, profanity)
   - Variable length
   - No guaranteed uniqueness without database

### Prior Art

- **UUIDs (RFC 4122)**: Random/time-based, 128-bit
- **Base62 encoding**: Used by URL shorteners (bit.ly, goo.gl)
- **Crockford Base32**: Excludes I, L, O, U - but allows duplicates
- **Hashids**: Obfuscates integers - not pure permutation
- **Nanoid**: Random generation - not sequential

### Novel Contribution

This is the **first system** to:
1. Use **permutations without replacement** for identifier generation
2. **Exclude vowels entirely** (prevents accidental words)
3. Provide **exact total count** (1,235,520 - mathematically bounded)
4. Enable **sequential generation** (deterministic next-code function)
5. Guarantee **lexicographic sorting** (alphabetical order works)

---

## DETAILED DESCRIPTION

### System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    GRAINORDER GENERATOR                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ALPHABET SPECIFICATION:                                            │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │ Characters: x b d g h j k l m n s v z                        │  │
│  │ Count: 13 (all consonants)                                   │  │
│  │ Excluded: a e i o u y (vowels)                               │  │
│  │           c f p q r t w (other consonants)                   │  │
│  │ Reason: Visual distinction, no accidental words              │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  CODE GENERATION:                                                   │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │ Length: 6 characters                                         │  │
│  │ Rule: No character may repeat within a code                  │  │
│  │                                                              │  │
│  │ Position 1: Choose from 13 chars                            │  │
│  │ Position 2: Choose from 12 remaining chars                  │  │
│  │ Position 3: Choose from 11 remaining chars                  │  │
│  │ Position 4: Choose from 10 remaining chars                  │  │
│  │ Position 5: Choose from 9 remaining chars                   │  │
│  │ Position 6: Choose from 8 remaining chars                   │  │
│  │                                                              │  │
│  │ Total: 13 × 12 × 11 × 10 × 9 × 8 = 1,235,520              │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  VALIDATION:                                                        │
│  └─ valid-grainorder?(code):                                       │
│     ✓ Length == 6                                                  │
│     ✓ All chars in alphabet                                        │
│     ✓ No duplicates (distinct chars only)                          │
│                                                                     │
│  NEXT CODE FUNCTION:                                                │
│  └─ next-grainorder(current):                                      │
│     1. Start at rightmost position                                 │
│     2. Try incrementing to next alphabet char                      │
│     3. If no duplicates, return new code                           │
│     4. If duplicates or overflow, carry left                       │
│     5. Repeat until valid code found or overflow                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Mathematical Foundation

**Permutations Without Replacement**:
```
P(n,k) = n! / (n-k)!

Where:
  n = alphabet size = 13
  k = code length = 6

P(13,6) = 13! / (13-6)!
        = 13! / 7!
        = (13 × 12 × 11 × 10 × 9 × 8 × 7!) / 7!
        = 13 × 12 × 11 × 10 × 9 × 8
        = 1,235,520
```

**First Code**: xbdghj (alphabetically first valid code)  
**Last Code**: zmnsvx (alphabetically last valid code)

### Example Sequence

```
xbdghj → xbdghk → xbdghl → xbdghm → xbdghn → xbdghs → xbdghv → xbdghz
   ↓
Each arrow represents next-grainorder() function call
Each code is unique, sequential, and has no duplicate characters
```

### Validation Examples

```
✓ xbdghj → Valid (all different chars)
✗ xbdghh → Invalid (h appears twice)
✓ zmnsvx → Valid (all different chars)
✗ abcdef → Invalid (chars not in alphabet)
✗ xbd    → Invalid (length != 6)
```

---

## CLAIMS

### Claim 1 (Independent - Method)
A computer-implemented method for generating unique identifiers, comprising:
- Defining a constrained alphabet consisting of exactly 13 consonant characters selected to avoid vowels and ambiguous characters;
- Generating a sequence of N-character codes (where N equals 6) from said alphabet;
- Ensuring each character appears at most once within any individual code;
- Providing a next-code function that deterministically generates the lexicographically next valid code in said sequence;
- Validating codes by verifying character distinctness and alphabet membership;
whereby the total number of possible codes equals 13!/(13-6)! = 1,235,520.

### Claim 2 (Dependent)
The method of Claim 1, wherein said alphabet consists of the characters: x, b, d, g, h, j, k, l, m, n, s, v, and z.

### Claim 3 (Dependent)
The method of Claim 1, wherein said next-code function operates in O(N) time complexity, where N is the code length.

### Claim 4 (Dependent)
The method of Claim 1, wherein said codes are used as file naming prefixes in a content management system.

### Claim 5 (Dependent)
The method of Claim 1, further comprising mapping arbitrary content to said codes in sequential order, creating an ordered knowledge base of exactly 1,235,520 addressable items.

### Claim 6 (Independent - System)
An identifier generation system comprising:
- A processor configured to execute identifier generation algorithms;
- A memory storing an alphabet definition of 13 consonants;
- A validation module that ensures character distinctness within codes;
- A sequence generation module that produces lexicographically ordered 6-character codes;
- A storage mapping module that associates said codes with content items.

### Claim 7 (Dependent - System)
The system of Claim 6, wherein said codes are used to address educational content items in an 80×110 monospace format (as claimed in related application).

### Claim 8 (Dependent - Integration)
The system of Claim 6, further integrated with a temporal version control system (as claimed in related application) wherein said codes namespace content within temporally-stamped branches.

---

## DRAWINGS

### Figure 1: Alphabet Selection
```
All Consonants: b c d f g h j k l m n p q r s t v w x y z
                ↓
Remove Vowels:  b c d f g h j k l m n p q r s t v w x z
                ↓
Remove y:       b c d f g h j k l m n p q r s t v w x z
                ↓
Select 13:      x b d g h j k l m n s v z
                ↓
Properties:     Visual distinction
                No confusables (no c/e, f/t, p/q)
                Pronounceable as letters
                Cross-cultural clarity
```

### Figure 2: Code Generation Algorithm
```
Input: current code "xbdghj"
       ↓
Step 1: Get rightmost char 'j'
       ↓
Step 2: Find next valid char that doesn't duplicate
       ↓
Step 3: Found 'k' (no duplicate)
       ↓
Output: "xbdghk"

Input: current code "xbdghz" (z is last in alphabet)
       ↓
Step 1: Get rightmost char 'z'
       ↓
Step 2: No chars after 'z', overflow
       ↓
Step 3: Carry left to position 5 ('h')
       ↓
Step 4: Find next valid after 'h' that doesn't duplicate
       ↓
Step 5: Found 'j'
       ↓
Output: "xbdgjk" (h→j, z→k)
```

### Figure 3: Use Case - Content Addressing
```
Content Item 1 → xbdghj → "Grainbranch README Sync (Steel)"
Content Item 2 → xbdghk → "Grainbranch README Sync (Steel)"
Content Item 3 → xbdghl → "Graincard Format Specification"
     ...
Content Item 1,235,520 → zmnsvx → "Final Knowledge Card"
```

---

## PRIOR ART ANALYSIS

### Patents Searched
- **US20150006486A1**: "System for generating unique identifiers" (Base64, allows duplicates)
- **US8930691B2**: "Unique identifier generation" (Random, not sequential)
- **US9292503B1**: "Short URL generation" (Base62, includes vowels)

### Academic Literature
- Knuth (Permutation generation algorithms) - but not for identifiers
- Base-N encoding papers - but allow character repetition
- Hash function research - but not human-readable

### Existing Systems
- **Crockford Base32**: Excludes I,L,O,U but allows duplicates
- **Base58** (Bitcoin): Excludes 0,O,I,l but allows duplicates
- **Hashids**: Obfuscates integers, not pure permutation

**Conclusion**: NO prior art uses permutations without replacement for sequential identifier generation with vowel-free constraint.

---

## COMMERCIAL APPLICATIONS

1. **Knowledge Management**: 1.2M unique addresses for educational content (grainscript)
2. **File Systems**: Deterministic naming without collisions
3. **Database Indexing**: Human-readable primary keys
4. **URL Shortening**: Guaranteed uniqueness without profanity
5. **Product SKUs**: Sequential codes for inventory (bounded quantity)
6. **Conference Rooms**: Memorable, pronounceable room codes
7. **License Keys**: Bounded key space with predictable exhaustion

---

## ADVANTAGES OVER PRIOR ART

### vs. UUIDs
- ✓ Human-readable (xbdghj vs 550e8400-e29b-41d4-a716-446655440000)
- ✓ Shorter (6 chars vs 36)
- ✓ Sequential (can predict next)
- ✓ Bounded (know exact total)

### vs. Base62/Base64
- ✓ No vowels (no accidental profanity)
- ✓ No duplicates (visually distinct)
- ✓ Pronounceable (can verbalize "x-b-d-g-h-j")
- ✓ Fixed length (always 6 chars)

### vs. Auto-increment Integers
- ✓ Doesn't reveal scale (1,235,520 total but doesn't show current count)
- ✓ Distributed-friendly (no central counter needed)
- ✓ Memorable (letters vs numbers)
- ✓ Cross-language (no locale issues)

---

## IMPLEMENTATION

**Reference Implementation**:
- Location: `grainstore/grain12pbc/teamillumine13/grainorder/`
- Language: Clojure
- Functions:
  - `valid-grainorder?` - O(N) validation
  - `next-grainorder` - O(N×M) next code (N=length, M=alphabet size)
  - `grainorder-seq` - Lazy sequence generation
  - `first-n-grainorders` - Batch generation

**Example Code** (Simplified):
```clojure
(defn next-grainorder [current]
  (loop [pos 5] ;; Start at rightmost
    (let [next-char (find-next-valid-char pos current)]
      (if next-char
        (assoc-char current pos next-char)
        (recur (dec pos)))))) ;; Carry left
```

---

## CLAIMS

### Claim 1 (Independent - Method)
A computer-implemented method for generating unique identifiers, comprising:
- Defining an alphabet of exactly 13 consonant characters excluding all vowels;
- Generating codes of exactly 6 characters selected from said alphabet;
- Constraining said codes such that no character appears more than once within any individual code;
- Implementing a next-code function that deterministically generates a lexicographically subsequent code;
- Validating codes by verifying each character is from said alphabet and appears exactly once;
whereby the total number of possible unique codes equals the permutation 13!/(13-6)! = 1,235,520.

### Claim 2 (Dependent - Specific Alphabet)
The method of Claim 1, wherein said alphabet consists of: x, b, d, g, h, j, k, l, m, n, s, v, z.

### Claim 3 (Dependent - Efficiency)
The method of Claim 1, wherein said next-code function executes in time complexity O(k×m) where k is code length and m is alphabet size.

### Claim 4 (Dependent - Lazy Evaluation)
The method of Claim 1, further comprising generating an infinite lazy sequence of codes, yielding the next valid code only when requested.

### Claim 5 (Dependent - Content Mapping)
The method of Claim 1, further comprising associating each generated code with a content item in a one-to-one mapping, creating an ordered knowledge base.

### Claim 6 (Independent - System)
An identifier generation system comprising:
- A memory storing an alphabet definition;
- A processor executing a permutation algorithm that selects k characters from n alphabet characters without replacement;
- A validation circuit that verifies character distinctness;
- A sequence generator producing lexicographically ordered codes;
whereby exactly n!/(n-k)! unique codes are generated.

### Claim 7 (Dependent - Specific Parameters)
The system of Claim 6, wherein n equals 13 and k equals 6, generating exactly 1,235,520 codes.

### Claim 8 (Dependent - File Naming)
The system of Claim 6, wherein said codes are used as file naming prefixes, enabling alphabetical sorting of up to 1,235,520 files.

### Claim 9 (Dependent - Integration)
The system of Claim 6, integrated with an educational content system wherein said codes address individual teaching cards in a fixed-dimension monospace format.

---

## EMBODIMENTS

### Embodiment 1: Knowledge Base (grainscript)
- 1,235,520 educational cards
- Each card addressed by unique grainorder code
- Sequential access via next-code links
- Example: xbdghj → xbdghk → xbdghl

### Embodiment 2: File System
- Directory with 1M+ files
- Each filename prefixed with grainorder code
- Alphabetical sorting works naturally
- Example: `xbdghj-readme.md`, `xbdghk-config.json`

### Embodiment 3: Database Indexing
- Primary keys as grainorder codes
- Human-readable in logs/URLs
- Sequential insertion maintains order
- Example: `/api/items/xbdghj`

### Embodiment 4: Product SKUs
- Bounded product space (up to 1.2M products)
- Pronounceable over phone ("x-b-d-g-h-j")
- No profanity risk (no vowels)
- Example: SKU-xbdghj

---

## ADVANTAGES

### Technical Advantages
1. **Deterministic**: Same input → same output (reproducible)
2. **Sequential**: Can generate in order without database
3. **Bounded**: Know exact capacity (1,235,520)
4. **Sortable**: Lexicographic order works naturally
5. **Validatable**: O(N) time to check validity

### Human Advantages
1. **Readable**: Letters, not hex digits
2. **Pronounceable**: Can speak codes ("x-b-d-g-h-j")
3. **Memorable**: Pattern recognition (xbd-ghj)
4. **Professional**: No profanity (no vowels)
5. **Cross-cultural**: Consonants work in most languages

### Business Advantages
1. **Scalable**: 1.2M items before exhaustion
2. **Private**: Doesn't reveal current item count
3. **Distributed**: No central authority needed
4. **Brandable**: Can trademark codes (consonant-only)

---

## PRIOR ART COMPARISON TABLE

| System | Sequential | No Vowels | No Dups | Bounded | Human-Readable |
|--------|-----------|-----------|---------|---------|----------------|
| UUID | ✗ | ✗ | ✗ | ✗ | ✗ |
| Auto-int | ✓ | N/A | ✓ | ✗ | ✓ |
| Base62 | ✗ | ✗ | ✗ | ✗ | Partial |
| Hashids | ✗ | ✗ | ✗ | ✗ | Partial |
| **Grainorder** | **✓** | **✓** | **✓** | **✓** | **✓** |

---

## IMPLEMENTATION DETAILS

### Algorithm Complexity

**next-grainorder()**:
- Best case: O(1) - increment rightmost position
- Average case: O(k) - k = code length = 6
- Worst case: O(k×m) - k = length, m = alphabet size = 13

**validate-grainorder()**:
- O(k) - check each character once

**Space Complexity**:
- O(k) - store single code
- O(n) - store alphabet
- Total: O(k + n) = O(6 + 13) = O(19) = O(1) constant

### Error Handling

**Overflow Detection**:
```
If current code = "zmnsvx" (last possible code)
Then next-grainorder(current) = nil
System gracefully returns null/nil/None
```

**Invalid Input**:
```
If input contains duplicates → Validation fails
If input has wrong length → Validation fails
If input has invalid chars → Validation fails
```

---

## COMMERCIAL VALUE

### Addressable Markets
1. **Content Management Systems**: $7.5B market (Gartner 2025)
2. **Knowledge Bases**: $1.2B market (KM software)
3. **E-commerce**: SKU generation for 100M+ retailers
4. **Education**: Learning management systems (Coursera, Udemy scale)

### Licensing Potential
- License to CMS providers (WordPress, Drupal, Ghost)
- Integration with knowledge bases (Notion, Obsidian, Roam)
- Academic use (open access with attribution)
- Enterprise use (commercial license)

---

## DRAWINGS (For Official Filing)

### Figure 1: Alphabet Selection Flowchart
(Professional diagram showing decision tree for alphabet selection)

### Figure 2: Next-Code Algorithm Flowchart
(Professional diagram showing loop logic with carry operations)

### Figure 3: System Architecture Diagram
(Block diagram showing modules: validation, generation, sequencing)

### Figure 4: Use Case Diagram
(Shows grainorder integration with file systems, databases, URLs)

---

## RELATED APPLICATIONS

This application relates to:
- **Patent #1**: Graintime (uses grainorder for content addressing)
- **Patent #3**: Grainscript (uses grainorder codes as card identifiers)
- **Patent #6**: Umbrella system (grainorder as addressing layer)

---

**Copyright © 3x39**  
**Inventors: kae3g (kj3x39, @risc.love)**  
**Filing Status: Provisional Application - Ready for USPTO submission**

now == next + 1 🏛️🌾

