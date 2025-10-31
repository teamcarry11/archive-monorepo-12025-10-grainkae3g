# rust os license comparison

**date**: 12025-10-31--1515--pdt--moon-shatabhisha--asc-pisc00--sun-09h  
**team**: teamcarry11 (t11aq, airbender mode)  
**purpose**: understand license implications for grain network

---

## license comparison

| os | license | type | grain network compatibility |
|----|---------|------|----------------------------|
| **redox** | MIT | permissive | ✅ fully compatible |
| **aero** | **GPLv3** | copyleft | ⚠️ requires GPLv3 for derivatives |
| **hermit** | unknown | unknown | ? need to check |

---

## license details

### redox: MIT license

**what it means**:
- ✅ use in any project (commercial or open source)
- ✅ modify without restrictions
- ✅ keep modifications private
- ✅ distribute with any license
- ✅ no source code requirement

**grain network fit**: ✅ perfect! we use MIT/Apache 2.0, fully compatible.

**reference**: redox codebase uses MIT license

---

### aero: GPLv3 license

**what it means**:
- ✅ use freely
- ✅ modify freely
- ⚠️ **must release source code** if you distribute
- ⚠️ **derivative works must be GPLv3**
- ⚠️ cannot mix with proprietary code (in same work)

**grain network fit**: ⚠️ careful! if we modify aero, we must use GPLv3.

**reference**: https://github.com/Andy-Python-Programmer/aero (GPL-3.0 license)

**key point**: GPLv3 is copyleft - it requires sharing source code and using GPLv3 for derivatives.

---

## implications for grain network

### using redox (MIT)

**scenario**: use redox kernel/modules in grain network

**can we**:
- ✅ use redox code? yes!
- ✅ modify redox code? yes!
- ✅ keep modifications private? yes!
- ✅ use our MIT/Apache 2.0 license? yes!

**result**: fully compatible, no license conflicts.

---

### using aero (GPLv3)

**scenario**: use aero kernel/modules in grain network

**can we**:
- ✅ use aero code? yes!
- ✅ modify aero code? yes!
- ⚠️ keep modifications private? **no!** (must release source)
- ⚠️ use our MIT/Apache 2.0 license? **no!** (must use GPLv3)

**result**: if we modify aero, we must:
1. release source code
2. use GPLv3 for derivative works
3. cannot mix with proprietary code

---

## strategies for grain network

### strategy 1: use redox (MIT) - recommended

**why**: 
- MIT license fully compatible
- no license conflicts
- can mix with our MIT/Apache 2.0 code
- freedom to keep modifications private (if needed)

**when**: primary rust os choice

---

### strategy 2: use aero (GPLv3) - careful

**if we use aero**:
- ✅ use as-is without modification: ok (but what's the point?)
- ⚠️ modify aero code: must release source + use GPLv3
- ⚠️ create derivative works: must use GPLv3

**possible approach**:
- use aero as inspiration (study design, don't copy code)
- write our own monolithic kernel (if needed)
- keep grain network MIT/Apache 2.0

---

### strategy 3: dual licensing

**if we need both**:
- redox components: MIT (our license)
- aero components: GPLv3 (separate, isolated)
- grain network core: MIT/Apache 2.0

**challenge**: must keep GPLv3 code separate from MIT code (legal isolation)

---

## grain network license

**current**: MIT + Apache 2.0 (dual license, user's choice)

**compatibility**:
- ✅ redox (MIT): fully compatible
- ⚠️ aero (GPLv3): requires GPLv3 for derivatives

**recommendation**: stick with redox (MIT) or write our own kernel (MIT/Apache 2.0)

---

## gplv3 in detail

### what is GPLv3?

**GNU General Public License version 3**:
- copyleft license (requires sharing source)
- derivative works must be GPLv3
- cannot mix with proprietary code
- must include license and source code

**philosophy**: "if you use/modify, you must share"

**contrast**: MIT says "do whatever you want, just include license"

---

### when GPLv3 applies

**you must use GPLv3 if**:
- you modify GPLv3 code
- you create derivative works
- you distribute modified GPLv3 code

**you don't need GPLv3 if**:
- you use GPLv3 code as-is (without modification)
- you don't distribute
- you only link (sometimes - complex!)

**key point**: modifying aero = must use GPLv3 for those modifications.

---

## decision matrix

### for grain network

| action | redox (MIT) | aero (GPLv3) |
|--------|-------------|--------------|
| **use code** | ✅ yes, any license | ✅ yes, but... |
| **modify code** | ✅ yes, keep private ok | ⚠️ yes, must share source |
| **distribute** | ✅ yes, any license | ⚠️ yes, must include source |
| **mix with MIT** | ✅ yes, fully compatible | ⚠️ careful (legal isolation) |
| **keep private** | ✅ yes | ❌ no (if distributed) |

---

## recommendations

### primary: redox (MIT)

**why**:
- license compatibility (MIT)
- no legal concerns
- full freedom to modify
- can keep grain network MIT/Apache 2.0

---

### secondary: aero (GPLv3) - inspiration only

**approach**:
- study aero design (ok, no license issue)
- learn from aero code (ok, no license issue)
- don't copy/modify aero code (unless we accept GPLv3)
- write our own kernel if needed (MIT/Apache 2.0)

---

### alternative: write our own

**if we need monolithic kernel**:
- write from scratch (MIT/Apache 2.0)
- inspired by aero design (ok, no license issue)
- inspired by linux design (ok, no license issue)
- keep grain network license (MIT/Apache 2.0)

---

## questions to answer

### for grain network

1. **do we need to modify aero?**
   - if yes: must use GPLv3 for those parts
   - if no: can use as-is (but limited value)

2. **do we want monolithic kernel?**
   - if yes: consider writing our own (MIT/Apache 2.0)
   - or: accept GPLv3 for aero-based components

3. **do we need source-level compatibility?**
   - if yes: aero might help (but GPLv3)
   - if no: redox is fine (MIT)

---

## resources

### aero license
- github: https://github.com/Andy-Python-Programmer/aero
- license: GPL-3.0 (see LICENSE file)
- note: derivative works must be GPLv3

### redox license
- gitlab: https://gitlab.redox-os.org/redox-os/redox
- license: MIT (permissive)
- note: fully compatible with grain network

### GPLv3 resources
- official: https://www.gnu.org/licenses/gpl-3.0.html
- summary: requires sharing source code for derivatives

---

**airbender mode**: licenses flow like water - understand them, choose wisely! 🌊

**key insight**: GPLv3 requires sharing - make sure we're ok with that if we use aero!

