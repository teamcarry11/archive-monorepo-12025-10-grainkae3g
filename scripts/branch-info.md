# branch information

**date**: 12025-10-31--1515--pdt--moon-shatabhisha--asc-pisc00--sun-09h  
**team**: teamcarry11 (t11aq, airbender mode)  
**mode**: temporal + kid-friendly + one-indexed

---

## stable default branch

**name**: `12025-10-31--1515--pdt--moon-shatabhisha--asc-pisc00--sun-09h`

**astro data**:
- **time**: 12025-10-31--1515--pdt
- **moon**: shatabhisha (100 stars)
- **ascendant**: pisc00 (pisces 0°)
- **sun**: 09h (9th house)

**status**: stable default branch  
**purpose**: main development branch with stable astro context

---

## unstable branch

**name**: `12025-10-31--1525--pdt--moon-shatabhisha--asc-pisc04--sun-09h`

**astro data**:
- **time**: 12025-10-31--1525--pdt
- **moon**: shatabhisha (100 stars)
- **ascendant**: pisc04 (pisces 4°)
- **sun**: 09h (9th house)

**status**: unstable branch  
**purpose**: experimental development with shifted ascendant

**difference from stable**:
- ascendant moved from pisc00 to pisc04 (4° shift)
- time moved forward 10 minutes (1515 → 1525)

---

## branch naming convention

branches use graintime format:
```
12025-10-31--HHMM--PDT--moon-MOON--asc-SIGNDEG--sun-HOUSEh
```

**components**:
- `12025-10-31`: date
- `--1515--PDT`: time and timezone
- `--moon-shatabhisha`: moon nakshatra
- `--asc-pisc00`: ascendant sign and degree
- `--sun-09h`: sun house position

---

## astro context

**moon shatabhisha**:
- 100 stars constellation
- healing, medicine, transformation
- breaking boundaries, liberation

**ascendant pisces**:
- water sign, mutable
- intuitive, compassionate, dreamy
- pisc00: beginning of pisces (0°)
- pisc04: early pisces (4°)

**sun 9th house**:
- higher learning, philosophy, travel
- long-distance journeys, expansion
- wisdom, truth-seeking

---

**current branch**: check with `git branch --show-current`  
**switch branches**: `git checkout <branch-name>`

