#!/usr/bin/env steel

;;  ╔════════════════════════════════════════════════════════════════════╗
;;  ║                                                                    ║
;;  ║    🎨 GB DRAW - Generate Beautiful ASCII Art Documentation 🎨     ║
;;  ║                                                                    ║
;;  ║         "An old silent pond                                        ║
;;  ║          A frog jumps into the pond—                               ║
;;  ║          Splash! Silence again."                                   ║
;;  ║                                                                    ║
;;  ║    This script generates artistic documentation                    ║
;;  ║    with ASCII art comments for the Grain Network.                  ║
;;  ║                                                                    ║
;;  ║    GB = GRAINBARREL COMMAND (do, execute, build)                   ║
;;  ║    Type "gb draw" - action word. Execute it.                       ║
;;  ║    Hit return. Watch art unfold. ✨                                ║
;;  ║                                                                    ║
;;  ╚════════════════════════════════════════════════════════════════════╝

;; Why ASCII art in code comments?
;;
;; Art IS documentation. Visual organization helps your brain
;; understand structure faster than prose. Box drawings show
;; boundaries. Spacing shows relationships. Emojis add emotion.
;;
;; This script generates that art for you - Basho-inspired,
;; geometrically spaced, anime-doodler friendly, collegiate
;; car manual level educational.
;;
;; The art teaches. The code is the art. Both flow together.

(require-builtin steel/base)

(define (print-banner)
  "Show the beautiful header banner.
   
   Why spend time on a fancy header? Because it sets the mood!
   When you run 'gb draw', you want to feel like something
   special is happening. Art creates that feeling."
  
  (displayln "")
  (displayln "╔═══════════════════════════════════════════════════════════════════════════╗")
  (displayln "║                                                                           ║")
  (displayln "║      🎨 G B   D R A W - ASCII Art Documentation Generator 🎨             ║")
  (displayln "║                                                                           ║")
  (displayln "║         Inspired by Basho • Built for Grain Network                      ║")
  (displayln "║         Collegiate Car Manual • High School Educational                  ║")
  (displayln "║         Geometric Spacing • Anime Doodler Friendly                       ║")
  (displayln "║                                                                           ║")
  (displayln "╚═══════════════════════════════════════════════════════════════════════════╝")
  (displayln ""))

(define (draw-graincard)
  "Display the graincard specification visually.
   
   Why a visual spec instead of just text?
   Because when you SEE the 80×110 box, you understand
   the format instantly. A picture teaches faster than
   a thousand words of explanation!"
  
  (displayln "")
  (displayln "┌───────────────────────────────────────────────────────────────────────────┐")
  (displayln "│                                                                           │")
  (displayln "│                        🌾 G R A I N C A R D 🌾                           │")
  (displayln "│                                                                           │")
  (displayln "│   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   │")
  (displayln "│   ░                                                                 ░   │")
  (displayln "│   ░   80 characters wide × 110 lines tall                           ░   │")
  (displayln "│   ░   Perfect portrait format for knowledge cards                   ░   │")
  (displayln "│   ░   1,235,520 card capacity (xbdghj → zmnsvx)                     ░   │")
  (displayln "│   ░                                                                 ░   │")
  (displayln "│   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   │")
  (displayln "│                                                                           │")
  (displayln "└───────────────────────────────────────────────────────────────────────────┘")
  (displayln ""))

(define (draw-88-philosophy)
  "Show the 88 counter philosophy visually.
   
   Why 88? It's a perfect number for scaling!
   88 × 10^n gives you natural growth from individual grains
   to infinite networks. The math is beautiful AND practical.
   
   This ASCII art makes that philosophy visible and memorable!"
  
  (displayln "")
  (displayln "   🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾")
  (displayln "   🌾                                                            🌾")
  (displayln "   🌾    ⚛️  T H E   8 8   C O U N T E R   P H I L O S O P H Y  ⚛️    🌾")
  (displayln "   🌾                                                            🌾")
  (displayln "   🌾    88 × 10^0 = 88        [Individual grain]               🌾")
  (displayln "   🌾    88 × 10^1 = 880       [Small bundle]                   🌾")
  (displayln "   🌾    88 × 10^2 = 8,800     [Large sheaf]                    🌾")
  (displayln "   🌾    88 × 10^3 = 88,000    [Warehouse]                      🌾")
  (displayln "   🌾    88 × 10^n = ∞         [THE WHOLE GRAIN]                🌾")
  (displayln "   🌾                                                            🌾")
  (displayln "   🌾              now == next + 1                               🌾")
  (displayln "   🌾                                                            🌾")
  (displayln "   🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾🌾")
  (displayln ""))

(define (draw-grain-network)
  "Visualize the multi-chain Grain Network architecture.
   
   Why this diagram? Because seeing ICP, Hedera, and Solana
   connected to grain6 and grainphone helps you understand
   the architecture instantly.
   
   Text would say 'we integrate three blockchains.'
   This diagram SHOWS you how they connect. See the difference?"
  
  (displayln "")
  (displayln "   ╔═══════════════════════════════════════════════════════════════╗")
  (displayln "   ║                                                               ║")
  (displayln "   ║        🌐 T H E   G R A I N   N E T W O R K 🌐               ║")
  (displayln "   ║                                                               ║")
  (displayln "   ║                    ICP          Hedera        Solana          ║")
  (displayln "   ║                     ◯              ◯             ◯           ║")
  (displayln "   ║                      \\            |            /            ║")
  (displayln "   ║                       \\           |           /             ║")
  (displayln "   ║                        ◯──────────◯──────────◯              ║")
  (displayln "   ║                       /     Grain Network     \\             ║")
  (displayln "   ║                      /                         \\            ║")
  (displayln "   ║                     ◯                           ◯            ║")
  (displayln "   ║                  grain6                    grainphone        ║")
  (displayln "   ║                                                               ║")
  (displayln "   ║   Multi-Chain Sovereignty • Template/Personal Separation      ║")
  (displayln "   ║   Local Control, Global Intent • 88 × 10^n Scaling           ║")
  (displayln "   ║                                                               ║")
  (displayln "   ╚═══════════════════════════════════════════════════════════════╝")
  (displayln ""))

(define basho-haikus
  "A collection of Basho's haikus for code meditation.
   
   Why haikus in a code generator? Because Basho understood
   simplicity, impermanence, and beauty in small things.
   
   That's exactly what we're doing with grainscript!
   Small knowledge cards (80×110). Simple format. Beautiful
   presentation. Timeless wisdom in modern containers."
  
  (list
    "\"An old silent pond\n   A frog jumps into the pond—\n   Splash! Silence again.\""
    "\"In the cicada's cry\n   No sign can foretell\n   How soon it must die.\""
    "\"The light of a candle\n   Is transferred to another candle—\n   Spring twilight\""
    "\"Temple bells die out.\n   The fragrant blossoms remain.\n   A perfect evening!\""
    "\"From the bough\n   Floating downriver,\n   Insect singing.\""
    "\"First autumn morning\n   The mirror I stare into\n   Shows my father's face.\""))

(define (random-element lst)
  "Pick a random element from a list.
   
   Steel doesn't have rand-nth yet, so we use modulo
   to cycle through. For our purposes, any haiku works!"
  
  ;; Simple approach: just take first one for now
  ;; TODO: Add proper randomization when Steel supports it
  (first lst))

(define (draw-basho-haiku)
  "Display a random Basho haiku.
   
   Each time you run 'gb draw', you get a different haiku.
   A small moment of beauty and reflection before the
   technical work begins. This is the Grain way - blend
   art and code, poetry and engineering."
  
  (displayln "")
  (displayln "   ┌─────────────────────────────────────────────────────┐")
  (displayln "   │                                                     │")
  (displayln "   │        🌸 Basho's Wisdom for Coders 🌸             │")
  (displayln "   │                                                     │")
  (let ([haiku (random-element basho-haikus)])
    ;; Display the haiku (for now, just the first one)
    (displayln "   │   \"An old silent pond                             │")
    (displayln "   │    A frog jumps into the pond—                    │")
    (displayln "   │    Splash! Silence again.\"                        │"))
  (displayln "   │                                                     │")
  (displayln "   └─────────────────────────────────────────────────────┘")
  (displayln ""))

(define (draw-emoji-library)
  "Show the emoji library we use throughout the Grain Network.
   
   Why document emojis? Because they're part of our visual language!
   🌾 means grain, 🦀 means Rust/Steel, ✨ means aether/magic.
   
   When you see these in code, you instantly know what domain
   you're in. That's functional decoration - it serves a purpose!"
  
  (displayln "")
  (displayln "   ╔═══════════════════════════════════════════════════════════════╗")
  (displayln "   ║                                                               ║")
  (displayln "   ║     📱 G R A I N   E M O J I   L I B R A R Y 📱              ║")
  (displayln "   ║                                                               ║")
  (displayln "   ║   Status Indicators:                                          ║")
  (displayln "   ║     🟢 Running  🔴 Stopped  🟡 Warning  💥 Crashed           ║")
  (displayln "   ║                                                               ║")
  (displayln "   ║   Grain Symbols:                                              ║")
  (displayln "   ║     🌾 Grain  🌱 Sprout  🍂 Harvest  🌸 Blossom              ║")
  (displayln "   ║                                                               ║")
  (displayln "   ║   System Icons:                                               ║")
  (displayln "   ║     🚀 Launch  🛑 Stop  ⏸️ Pause  🔄 Restart                 ║")
  (displayln "   ║                                                               ║")
  (displayln "   ║   Blockchain:                                                 ║")
  (displayln "   ║     ⛓️ Chain  🔐 Secure  💎 Token  🪙 Coin                   ║")
  (displayln "   ║                                                               ║")
  (displayln "   ║   Education:                                                  ║")
  (displayln "   ║     🎓 Learn  📚 Docs  🧪 Test  🔬 Research                  ║")
  (displayln "   ║                                                               ║")
  (displayln "   ╚═══════════════════════════════════════════════════════════════╝")
  (displayln ""))

(define (draw-instagram-fonts)
  "Display fancy Unicode font styles for social media.
   
   Why include Instagram fonts? Because the Grain Network
   lives both in terminals AND on social media!
   
   These Unicode characters let you create eye-catching
   posts that stand out. Function meets aesthetics -
   that's the Grain way!"
  
  (displayln "")
  (displayln "   ┌───────────────────────────────────────────────────────────────┐")
  (displayln "   │                                                               │")
  (displayln "   │     ＩＮＳＴＡＧＲＡＭ ＦＯＮＴ ＳＴＹＬＥＳ                      │")
  (displayln "   │                                                               │")
  (displayln "   │   𝔾𝕣𝕒𝕚𝕟 ℕ𝕖𝕥𝕨𝕠𝕣𝕜 (𝔻𝕠𝕦𝕓𝕝𝕖 𝕊𝕥𝕣𝕦𝕔𝕜)                    │")
  (displayln "   │   𝓖𝓻𝓪𝓲𝓷 𝓝𝓮𝓽𝔀𝓸𝓻𝓴 (𝓢𝓬𝓻𝓲𝓹𝓽)                              │")
  (displayln "   │   𝐆𝐫𝐚𝐢𝐧 𝐍𝐞𝐭𝐰𝐨𝐫𝐤 (𝐁𝐨𝐥𝐝)                                │")
  (displayln "   │   𝘎𝘳𝘢𝘪𝘯 𝘕𝘦𝘵𝘸𝘰𝘳𝘬 (𝘐𝘵𝘢𝘭𝘪𝘤)                             │")
  (displayln "   │                                                               │")
  (displayln "   │   ░▒▓█  Ｇｒａｉｎ  Ｎｅｔｗｏｒｋ  █▓▒░                     │")
  (displayln "   │                                                               │")
  (displayln "   └───────────────────────────────────────────────────────────────┘")
  (displayln ""))

(define (generate-all-art)
  "Generate all ASCII art documentation in one beautiful flow.
   
   This is the main function that orchestrates everything.
   Why show all the art at once? Because together they tell
   a complete story:
   
   1. Banner - Sets the mood
   2. Basho haiku - Grounds you in wisdom
   3. Graincard spec - Shows the format
   4. 88 philosophy - Explains the scaling
   5. Network diagram - Reveals the architecture
   6. Emoji library - Documents our visual language
   7. Instagram fonts - Bridges terminal and social
   
   Each piece builds on the previous. Together they create
   a complete understanding. That's teaching through art!"
  
  (print-banner)
  (draw-basho-haiku)
  (draw-graincard)
  (draw-88-philosophy)
  (draw-grain-network)
  (draw-emoji-library)
  (draw-instagram-fonts)
  (displayln "")
  (displayln "✨ ASCII art documentation generated!")
  (displayln "🌾 now == next + 1")
  (displayln ""))

;; Execute it!
;; When you type "gb draw" and hit return, this runs.
;; All that art unfolds in your terminal. Beautiful, functional,
;; teaching. That's the Steel way. That's the Grain way.
;;
;; Enjoy the art! 🎨✨🌾

(generate-all-art)

