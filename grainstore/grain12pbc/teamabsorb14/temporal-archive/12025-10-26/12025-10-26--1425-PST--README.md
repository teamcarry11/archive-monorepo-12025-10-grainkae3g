# grainfriends - Personal Friendship Network

**Team**: teamplay04 (Cancer ♋ / IV. The Emperor)  
**Date**: 2025-10-26  
**Purpose**: Track friendships, connections, relationships (distinct from graincontacts)

---

## grainfriends vs graincontacts

**graincontacts** (professional/public):
- Public figures (Seb Alex, Helen Atthowe)
- Organizations (Middle East Vegan Society, DxE)
- Professional connections (potential partnerships)
- Public social media profiles

**grainfriends** (personal/private):
- Personal friends (Jenna, etc.)
- Private relationships (not public figures)
- Community connections (HappyCow, Discord, local)
- More intimate, less formal

**Both in team04**: Emperor nurtures ALL relationships (professional + personal)

---

## Structure

**File format**: `{friend-name}.edn`

**Fields**:
```clojure
{:id "friend-id"
 :type :friend
 :name "Display Name"
 :status :active  ; or :inactive, :archived
 
 :platforms
 {:happycow "username"
  :discord "username"
  :instagram "username"
  :signal "+1234567890"
  :email "email@example.com"}
 
 :discovered "YYYY-MM-DD"
 :context "How/where you met"
 
 :shared-interests
 ["interest1" "interest2"]
 
 :notes "Personal notes, memories, context"}
```

---

## Privacy

**grainfriends is PRIVATE**:
- Not published to grainsite (stays local)
- Not synced to public repos (unless explicitly chosen)
- Respects friend privacy (no public exposure without consent)

**Add to .gitignore**:
```
grainstore/grain12pbc/teamplay04/grainfriends/*.edn
!grainstore/grain12pbc/teamplay04/grainfriends/README.md
```

**Or keep public**: If friends are comfortable being in public repo (Jenna seems okay, but confirm first)

---

## Current Friends

### **Jenna**
- **Platforms**: HappyCow, Discord
- **Context**: Vegan community friend
- **Discovered**: 2025-10-26
- **Notes**: Enthusiastic about vegan aesthetics, HappyCow active user

---

## Integration with Other Modules

**graincontacts** (public/professional):
- Could graduate from grainfriends if friendship becomes professional partnership
- Example: If Jenna starts a vegan business → move to graincontacts

**grainpersona** (team10):
- Friends might inspire personas (like Glow V2 update)
- Real conversations shape code comments style

**graincrypto** (team07):
- Send crypto to friends (birthday gifts, meal splitting, etc.)
- Not just professional transactions

---

## Why This Matters

**Emperor energy** (team04):
- Nurtures ALL relationships (not just transactional)
- Foundation includes community (not just code)
- Leadership is CARE (personal + professional)

**Cancer/Moon**:
- Emotional connection (friends are family)
- Home/community building (grainfriends = chosen family)
- Protective (privacy settings, consent-based sharing)

**The Lovers** (team06 connection):
- Relationships are sacred (friends are treasured)
- Choice matters (who you keep close)
- Union of personal + professional (both/and, not either/or)

---

## Future

**As grain network grows**:
- grainfriends might have 10, 50, 100+ entries
- Community building (vegan dev friends, activist friends, etc.)
- Offline-first (EDN files, no database dependency)
- Searchable (grep, EDN queries, grainorder for alphabetical filing)

---

🌾 **now == next + 1**

**Team04**: Nurture friendships like you nurture code. Both need care, attention, and respect.

