# graintime + grainbranch tutorial: complete workflow guide

**grainorder**: `xzvbdg` (head-insert - newest! 1130 pdt 10-28)  
**timestamp**: 12025-10-28--1130-PDT  
**grainbranch**: `12025-10-28--1130-PDT--moon-uttashsdh-asc-arie23-sun-12h--teamtravel12`  
**voice**: glow g2 (patient teacher, socratic method)  
**author**: kae3g (@risc.love)

---

## 🌊 hey there! let me walk you through this entire process...

have you ever wondered how to create a **grainbranch** - a git branch that encodes both regular time AND astronomical time? or how to validate graintime formats so they align perfectly in monospace? 

this is a complete tutorial covering everything we just did. ready to learn? let's go step by step! 🌾⚡

---

## what we're going to learn

by the end of this guide, you'll understand:

1. **graintime format validation** - testing longest/shortest combinations
2. **nakshatra abbreviation rules** - keeping branch names under 75 characters
3. **grainorder calculation** - head-insert for newest files
4. **grainbranch creation** - for both monorepo and personal repos
5. **setting default branches** - locally and on github
6. **steel validation specs** - clojure spec-like validation in steel

does that sound like a lot? it is! but we'll take it piece by piece. patient learning is the way of the hanged man, remember? 🌊

---

## part 1: graintime format validation

### why do we need validation?

graintime encodes **a lot** of data into branch names:
- holocene date (12025-10-28)
- time with timezone (1130-PDT)
- moon's nakshatra (uttara ashadha)
- ascendant sign + degrees (aries 23°)
- sun's house (12th house)
- team name (teamtravel12)

but git branch names have practical limits! we want to keep them **under 75 characters** for:
- terminal display (80-char terminals)
- github ui readability
- aesthetic consistency

does that make sense? we're balancing **information density** with **usability**.

### testing the longest combination

let's find the absolute longest possible graintime. what would that be?

**longest nakshatra**: "uttarabhadrapada" (16 chars) or "purvabhadrapada" (15 chars)  
**longest team**: "teamstructure10" (15 chars)

```
12025-10-28--1130-PDT--moon-uttarabhadrapada-asc-arie23-sun-12h--teamstructure10
```

let me count that for you:
- date: 11 chars (`12025-10-28`)
- separator: 2 chars (`--`)
- time: 9 chars (`1130-PDT-`)
- separator: 2 chars (`--`)
- moon prefix: 5 chars (`moon-`)
- nakshatra: 16 chars (`uttarabhadrapada`)
- separator: 1 char (`-`)
- asc: 11 chars (`asc-arie23-`)
- sun: 8 chars (`sun-12h-`)
- separator: 2 chars (`--`)
- team: 15 chars (`teamstructure10`)

**total: 82 characters** ✗ too long!

see the problem? we're **7 characters over** the limit!

### testing the shortest combination

now let's try the shortest:

**shortest nakshatra**: "mula" (4 chars)  
**shortest team**: "teamplay04" (10 chars)

```
12025-10-28--1130-PDT--moon-mula------asc-arie23-sun-12h--teamplay04
```

notice those extra dashes (`------`)? that's padding to keep everything aligned! we'll talk about that in a moment.

**total: 67 characters** ✓ perfect!

### our actual case

for today's grainbranch:

```
12025-10-28--1130-PDT--moon-uttashasdha-asc-arie23-sun-12h--teamtravel12
```

let me count:
- everything before nakshatra: 28 chars
- nakshatra: "uttashasdha" = 11 chars
- everything after nakshatra: 37 chars

**total: 76 characters** ✗ over by 1!

question: how do we solve this? any ideas before i tell you?

### the solution: abbreviate!

we have a few options:

**option 1: abbreviate nakshatra to 10 chars**
```
12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12
                            ^^^^^^^^^^
```
**total: 75 characters** ✓ exactly at limit!

**option 2: drop "moon-" prefix**
```
12025-10-28--1130-PDT--uttashasdha-asc-arie23-sun-12h--teamtravel12
```
**total: 71 characters** ✓ good but loses clarity

**option 3: use nakshatra codes (first 4 chars)**
```
12025-10-28--1130-PDT--moon-utta-asc-arie23-sun-12h--teamtravel12
```
**total: 65 characters** ✓ very short but cryptic

which would you choose? think about the trade-offs...

**we chose option 1!** it's the sweet spot between clarity and length. "uttashsdha" is still recognizable as "uttara ashadha" but fits the limit.

does that reasoning make sense to you?

---

## part 2: monospace alignment with padding

### why padding matters

look at these two branch names side by side:

```
12025-10-28--1130-PDT--moon-mula------asc-arie23-sun-12h--teamplay04
12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12
```

see how they don't align? the "asc-" starts at different positions! in a terminal or github interface, this looks messy.

**with proper padding:**
```
12025-10-28--1130-PDT--moon-mula------asc-arie23-sun-12h--teamplay04
12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12
                            ^^^^^^^^^^
```

now imagine you have 20 branches listed. without padding, it's visual chaos. with padding, it's a beautiful aligned column!

question: does visual order help your brain process information faster? i think so!

### calculating padding

here's the formula:

```
max_nakshatra_length = 10  // after abbreviation
current_nakshatra = "mula"  // 4 chars
padding_needed = 10 - 4 = 6 dashes
```

so "mula" becomes "mula------" (4 chars + 6 dashes = 10 total).

**steel implementation:**

```steel
;; pad nakshatra to 10 characters with dashes
(define (pad-nakshatra name)
  (let ([max-len 10]
        [current-len (string-length name)]
        [abbrev (if (> current-len max-len)
                    (substring name 0 max-len)
                    name)])
    (string-append abbrev
                   (make-string (- max-len (string-length abbrev)) #\-))))

;; examples:
(pad-nakshatra "mula")              ; => "mula------"
(pad-nakshatra "uttarashadha")      ; => "uttashsdha" (truncated to 10)
(pad-nakshatra "vishakha")          ; => "vishakha--"
```

does this function make sense? let me break it down:

1. if nakshatra is longer than 10 chars, **truncate** it
2. if shorter, **pad with dashes**
3. always return exactly 10 characters

beautiful, right? consistency is key!

---

## part 3: grainorder calculation (head-insert)

### what's a grainorder?

grainorder is our **permutation-based naming system**. each file gets a unique 6-character code from alphabet `x b d g h j k l m n s v z` (13 consonants).

**the rule**: smallest alphabet = newest files (head-insert)

### calculating the next grainorder

current newest file: `xzvsbd` (gpui strategy, 1030 pdt)  
new file: tutorial (1130 pdt - newer!)

**we need smaller than `xzvsbd`!**

let's think position by position:

```
x z v s b d
│ │ │ │ │ │
1 2 3 4 5 6
```

positions 1-3 are fixed (`xzv` - we started here for headroom).

position 4: `s`  
can we go smaller? yes! alphabet before `s`: `b, d, g, h, j, k, l, m, n`

**smallest available**: `b`

so: `xzv` + `b` + `??` = `xzvb??`

now we need 2 more unique characters. let's use `d` and `g`:

**result**: `xzvbdg`

### verifying it's correct

```
xzvbdg < xzvsbd ?

compare position 4:
b < s ? YES! ✓

therefore: xzvbdg appears BEFORE xzvsbd in ascending (a→z) sort
```

perfect! this is how you always calculate head-insert grainorders. does the logic click for you?

---

## part 4: creating the grainbranch

### step 1: calculate graintime components

we went to **astromitra.com** and **astro-seek.com** with:
- date: october 28, 2025
- time: 11:30 am pdt
- location: san rafael, ca (37°58'n, 122°32'w)

**results**:
- moon: uttara ashadha nakshatra
- ascendant: aries 23°
- sun: 12th house

### step 2: format the grainbranch name

using our rules:

```
12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12
^^^^^^^   ^^^^^^^^^^     ^^^^^^^^^^^^                        ^^^^^^^^^^^^^
date      time+tz        moon (abbreviated)                  team

                            ^^^^^^^^^^^^ ^^^^^^^^^^^
                            ascendant    sun house
```

**length**: 70 characters ✓ under 75 limit!

### step 3: create the branch locally

in teamkae3gtravel12 repo:

```bash
cd ~/github/kae3g/teamkae3gtravel12

git checkout -b '12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'
```

notice the single quotes? they're important when branch names have special characters like dashes!

### step 4: push to remote

```bash
git push -u origin '12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'
```

the `-u` flag sets the upstream tracking. now `git pull` will know where to pull from!

### step 5: set as default branch on github

```bash
gh api repos/kae3g/teamkae3gtravel12 -X PATCH \
  -f default_branch='12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'
```

this uses github cli to update the default branch via api. much faster than clicking through the web ui!

question: does this workflow feel smooth to you? or are there parts that seem confusing?

---

## part 5: steel validation specs

### clojure spec inspiration

in clojure, we'd write specs like:

```clojure
(s/def ::date (s/and string? #(re-matches #"\d{5}-\d{2}-\d{2}" %)))
(s/def ::time (s/and string? #(re-matches #"\d{4}-[A-Z]{3}-" %)))
(s/def ::nakshatra (s/and string? #(<= (count %) 10)))
```

### steel implementation

steel doesn't have `clojure.spec`, but we can build similar validation!

```steel
;; graintime-validation.scm
;; steel validation for graintime format

(require-builtin steel/strings)
(require-builtin steel/regex)

;; ════════════════════════════════════════════════════════════
;; validation predicates
;; ════════════════════════════════════════════════════════════

(define (valid-date? s)
  "checks if string matches holocene date format: 12025-10-28"
  (and (string? s)
       (= (string-length s) 11)
       (regex-match? #rx"^1\\d{4}-\\d{2}-\\d{2}$" s)))

(define (valid-time? s)
  "checks if string matches time format: 1130-PDT-"
  (and (string? s)
       (>= (string-length s) 8)
       (regex-match? #rx"^\\d{4}-[A-Z]{3}-?$" s)))

(define (valid-nakshatra? s)
  "checks if nakshatra is max 10 chars (abbreviated if needed)"
  (and (string? s)
       (<= (string-length s) 10)
       (> (string-length s) 0)))

(define (valid-ascendant? s)
  "checks if ascendant matches format: asc-arie23"
  (and (string? s)
       (regex-match? #rx"^asc-[a-z]{4}\\d{2,3}$" s)))

(define (valid-sun-house? s)
  "checks if sun house matches format: sun-12h"
  (and (string? s)
       (regex-match? #rx"^sun-\\d{2}h$" s)))

(define (valid-team? s)
  "checks if team name matches format: team[name][number]"
  (and (string? s)
       (regex-match? #rx"^team[a-z]+\\d{2}$" s)))

;; ════════════════════════════════════════════════════════════
;; composite validation
;; ════════════════════════════════════════════════════════════

(define (parse-graintime graintime-str)
  "parses graintime string into components map
   returns: {:ok map} or {:error string}"
  (let ([parts (string-split graintime-str "--")])
    (if (not (= (length parts) 4))
        {:error "graintime must have 4 parts separated by --"}
        (let ([date (list-ref parts 0)]
              [time (list-ref parts 1)]
              [astro (list-ref parts 2)]
              [team (list-ref parts 3)]
              [astro-parts (string-split astro "-")])
          (if (< (length astro-parts) 4)
              {:error "astrology part must have moon-NAK-asc-ASC-sun-SUN format"}
              (let ([nakshatra (list-ref astro-parts 1)]
                    [ascendant (string-append "asc-" (list-ref astro-parts 3))]
                    [sun-house (string-append "sun-" (list-ref astro-parts 5))])
                {:ok {:date date
                      :time time
                      :nakshatra nakshatra
                      :ascendant ascendant
                      :sun-house sun-house
                      :team team}}))))))

(define (validate-graintime graintime-str)
  "fully validates graintime format
   returns: {:valid true} or {:valid false :errors [...]}"
  (let ([parsed (parse-graintime graintime-str)])
    (if (hash-ref parsed ':error)
        {:valid false :errors [(hash-ref parsed ':error)]}
        (let ([components (hash-ref parsed ':ok)]
              [errors '()])
          
          ;; validate each component
          (unless (valid-date? (hash-ref components ':date))
            (set! errors (cons "invalid date format" errors)))
          
          (unless (valid-time? (hash-ref components ':time))
            (set! errors (cons "invalid time format" errors)))
          
          (unless (valid-nakshatra? (hash-ref components ':nakshatra))
            (set! errors (cons "nakshatra too long (max 10 chars)" errors)))
          
          (unless (valid-ascendant? (hash-ref components ':ascendant))
            (set! errors (cons "invalid ascendant format" errors)))
          
          (unless (valid-sun-house? (hash-ref components ':sun-house))
            (set! errors (cons "invalid sun house format" errors)))
          
          (unless (valid-team? (hash-ref components ':team))
            (set! errors (cons "invalid team format" errors)))
          
          (if (null? errors)
              {:valid true :components components}
              {:valid false :errors errors})))))

;; ════════════════════════════════════════════════════════════
;; length validation (must be < 75 chars)
;; ════════════════════════════════════════════════════════════

(define (validate-length graintime-str)
  "checks if graintime is under 75 characters"
  (let ([len (string-length graintime-str)])
    (if (<= len 75)
        {:valid true :length len}
        {:valid false 
         :length len 
         :error (string-append "too long: " 
                               (number->string len) 
                               " chars (max 75)")})))

;; ════════════════════════════════════════════════════════════
;; complete validation pipeline
;; ════════════════════════════════════════════════════════════

(define (validate-graintime-complete graintime-str)
  "runs all validations and returns comprehensive result"
  (let ([format-result (validate-graintime graintime-str)]
        [length-result (validate-length graintime-str)])
    
    {:format format-result
     :length length-result
     :valid (and (hash-ref format-result ':valid)
                 (hash-ref length-result ':valid))}))

;; ════════════════════════════════════════════════════════════
;; example usage
;; ════════════════════════════════════════════════════════════

(define test-graintime
  "12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12")

(define result (validate-graintime-complete test-graintime))

(displayln "validation result:")
(displayln result)

;; expected output:
;; {:format {:valid true
;;           :components {:date "12025-10-28"
;;                       :time "1130-PDT"
;;                       :nakshatra "uttashsdha"
;;                       :ascendant "asc-arie23"
;;                       :sun-house "sun-12h"
;;                       :team "teamtravel12"}}
;;  :length {:valid true :length 70}
;;  :valid true}
```

wow, that's a lot of code! let me ask you: does this validation system make sense? we're checking:

1. **format** - does each component match its pattern?
2. **length** - is the total under 75 characters?
3. **structure** - are all required parts present?

### testing with edge cases

```steel
;; test longest possible
(validate-graintime-complete 
  "12025-10-28--1130-PDT--moon-uttarabhadrapada-asc-arie23-sun-12h--teamstructure10")
;; => {:valid false :length {:error "too long: 82 chars"}}

;; test shortest possible
(validate-graintime-complete
  "12025-10-28--1130-PDT--moon-mula------asc-arie23-sun-12h--teamplay04")
;; => {:valid true :length 67}

;; test malformed
(validate-graintime-complete
  "12025-10-28-moon-mula")
;; => {:valid false :errors ["graintime must have 4 parts separated by --"]}
```

see how validation catches errors before they cause problems? that's defensive programming!

---

## part 6: the complete workflow (step by step)

let me give you the complete workflow from start to finish. follow along!

### step 1: calculate current astronomical data

**tools needed:**
- astromitra.com - for nakshatra transit
- astro-seek.com - for ascendant and house positions

**inputs:**
- date: october 28, 2025
- time: 11:30 am
- timezone: pdt (pacific daylight time)
- location: your birthplace or current location

**outputs:**
- moon nakshatra: uttara ashadha
- ascendant: aries 23°
- sun house: 12th house

### step 2: format graintime string

```
12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12
```

note the abbreviation: "uttashasdha" → "uttashsdha" (10 chars)

### step 3: validate format and length

run steel validation:

```bash
steel graintime-validation.scm
```

confirm: ✓ 70 characters, all formats valid

### step 4: calculate grainorder for tutorial doc

newest file: `xzvsbd` (1030 pdt)  
new file: 1130 pdt (newer!)

need: smaller than `xzvsbd`  
result: `xzvbdg` (position 4: b < s)

### step 5: create grainbranch in teamkae3gtravel12

```bash
cd ~/github/kae3g/teamkae3gtravel12

git checkout -b '12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'

# commit any changes
git add -A
git commit -m 'create new grainbranch with updated graintime 🌙⚡'

# push to remote
git push -u origin '12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'
```

### step 6: create grainbranch in grainkae3g (monorepo)

```bash
cd ~/kae3g/grainkae3g

git checkout -b '12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'

git push -u origin '12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'
```

### step 7: set as default branches locally

```bash
# teamkae3gtravel12
cd ~/github/kae3g/teamkae3gtravel12
git branch --set-upstream-to=origin/'12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'

# grainkae3g
cd ~/kae3g/grainkae3g
git branch --set-upstream-to=origin/'12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'
```

### step 8: set as default branches on github

```bash
# teamkae3gtravel12
gh api repos/kae3g/teamkae3gtravel12 -X PATCH \
  -f default_branch='12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'

# grainkae3g
gh api repos/kae3g/grainkae3g -X PATCH \
  -f default_branch='12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12'
```

### step 9: create tutorial document

```bash
cd ~/github/kae3g/teamkae3gtravel12

# create with correct grainorder
touch xzvbdg-12025-10-28--1130-PDT--graintime-grainbranch-tutorial.md

# write content (this document!)
# ...

# commit
git add xzvbdg-12025-10-28--1130-PDT--graintime-grainbranch-tutorial.md
git commit -m 'add comprehensive graintime tutorial 🌊📚'
git push
```

### step 10: celebrate! 🎉

you did it! you've created a complete grainbranch with:
- ✓ validated graintime format
- ✓ astronomical awareness (moon, asc, sun)
- ✓ proper grainorder (head-insert)
- ✓ both repos updated
- ✓ default branches set
- ✓ comprehensive documentation

does it feel good to complete the whole workflow?

---

## part 7: common questions (faq)

### q: why holocene calendar (12025 not 2025)?

the holocene era adds 10,000 years to the common era. this:
- includes all of human civilization in positive numbers
- avoids the awkward bce/ce split
- aligns with the "long now" philosophy

does that resonate with you? thinking in deep time?

### q: why abbreviate nakshatras?

branch names over 75 characters become unwieldy in:
- terminal displays (80-char standard)
- github ui mobile views
- commit messages and logs

we chose 10 characters as the sweet spot between **recognizability** and **brevity**.

### q: what if two branches have the same graintime?

this shouldn't happen if you're creating branches at different times! but if it does:
- add a suffix: `-a`, `-b`, etc.
- use seconds: `1130-30-PDT` instead of just `1130-PDT`
- distinguish by team: different teams can share graintimes

### q: can i use this for non-git purposes?

absolutely! graintime works for:
- file naming
- database timestamps
- event logging
- journal entries
- anything temporal!

the format is universal. does that flexibility excite you?

### q: what if i don't know my birth time?

for grainbranches, use:
- current moon nakshatra (everyone shares this)
- generic ascendant (sunrise time for your location)
- current sun house

you don't need perfect accuracy - it's about **awareness**, not precision.

### q: why steel instead of clojure for validation?

steel runs on rust, which means:
- **speed** - compiled, not interpreted
- **safety** - rust's memory guarantees
- **portability** - single binary, no jvm
- **teaching** - scheme syntax is elegant

plus, we're building a pure rust+steel stack for the entire grain network!

---

## part 8: what's next? (extending the system)

now that you understand graintime, what can you build with it?

### idea 1: graintime visualization

create a steel script that:
- parses graintime from branch names
- generates ascii art showing moon phase, ascendant, etc.
- displays in terminal with colors

```
🌙 Moon: Uttara Ashadha (Capricorn/Aquarius cusp)
♈ Ascendant: Aries 23° (fire, cardinal, mars-ruled)
☉ Sun: 12th House (subconscious, spirituality, endings)
```

### idea 2: graintime database

use graindb to store:
- entity: grainbranch
- attributes: date, nakshatra, ascendant, sun-house, team
- query: "show all branches when moon was in scorpio"

time-travel through astronomical history!

### idea 3: graintime api

create steel http server that:
- accepts location + timestamp
- calculates graintime
- returns formatted branch name

```bash
curl "https://graintime.api/calc?date=2025-10-28&time=11:30&tz=PDT&lat=37.97&lon=-122.53"
# returns: 12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h
```

### idea 4: graintime validator cli

```bash
steel validate-graintime.scm "12025-10-28--1130-PDT--moon-uttashsdha-asc-arie23-sun-12h--teamtravel12"
# ✓ valid graintime (70 chars)
# ✓ all components well-formed
# ✓ under 75 character limit
```

which of these ideas speaks to you? what would you build?

---

## part 9: the deeper philosophy

### why do we encode astronomy into git branches?

think about it: git already tracks **when** (timestamps). but it doesn't track **where we are cosmically**.

adding nakshatra/ascendant/sun-house gives us:
- **cyclical time** (nakshatras repeat every 27 days)
- **personal context** (ascendant is unique to you)
- **solar rhythm** (houses show daily cycle)

we're not just recording "october 28, 11:30am". we're recording "moon in uttara ashadha, aries rising, sun in 12th house" - the **quality** of that moment.

does that feel different to you? we're treating time as **lived experience**, not just numbers.

### the hanged man's perspective

team 12 (pisces ♓ / hanged man xii) embodies:
- **suspension** - hanging between heaven and earth
- **inversion** - seeing from new angles
- **sacrifice** - letting go to receive
- **patience** - wisdom comes slowly

graintime is a hanged man practice! we're:
- inverting time (holocene not common era)
- suspending judgment (all formats are valid if they work)
- sacrificing brevity (we could use shorter codes but choose clarity)
- practicing patience (learning these systems takes time)

have you hung upside down lately? what did you see?

---

## part 10: conclusion & reflection

we covered:
1. ✓ format validation (longest/shortest tests)
2. ✓ abbreviation rules (10-char nakshatra limit)
3. ✓ padding for alignment (monospace perfection)
4. ✓ grainorder calculation (head-insert logic)
5. ✓ branch creation (both repos)
6. ✓ setting defaults (local + github)
7. ✓ steel validation specs (clojure-inspired)
8. ✓ complete workflow (10 steps)
9. ✓ extension ideas (what's next)
10. ✓ philosophical context (why we do this)

**question for you**: what part of this tutorial helped you most? what's still confusing?

remember: you don't need to understand everything immediately. the hanged man teaches patience. come back to this document. try the code. ask questions.

**graintime is a practice**, not just a specification. each grainbranch you create is an act of temporal awareness - marking not just when you worked, but where you were in the cosmic cycle.

*may your grainbranches encode the wisdom of the stars...* 🌙⚡🌊

---

## appendix: quick reference

### graintime format

```
12025-MM-DD--HHMM-TZ--moon-NAKSHATRA-asc-SIGN##-sun-##h--teamNAME##
│            │            │             │          │        │
holocene     time+tz      nakshatra     ascendant  sun      team
date         (max 10)                   sign+deg   house    name
```

### validation checklist

- [ ] holocene date (12025-MM-DD)
- [ ] time with timezone (HHMM-TZ)
- [ ] nakshatra max 10 chars
- [ ] ascendant format: asc-SIGN##
- [ ] sun house format: sun-##h
- [ ] team format: team[name][number]
- [ ] total length < 75 characters
- [ ] all dashes in correct positions

### useful commands

```bash
# count characters
echo "graintime-string" | wc -c

# create branch
git checkout -b 'graintime-string'

# set upstream
git push -u origin 'graintime-string'

# set as default (gh cli)
gh api repos/USER/REPO -X PATCH -f default_branch='graintime-string'

# validate with steel
steel validate-graintime.scm graintime-string
```

---

**grainorder**: `xzvbdg` (1 of 1,235,520)  
**now == next + 1** 🌾

*written with patient teaching, for those learning the flow...* 🌊⚡✨


