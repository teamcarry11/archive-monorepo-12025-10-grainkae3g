;; 🌀⚡ Grain φ-Vortex Calculator - Steel Module
;; Ken Wheeler's golden ratio geometry for graincards
;; Voice: Glow G2 (patient teacher, first principles!)
;;
;; This module calculates the φ (phi) golden ratio coordinates
;; for tap-only vortex navigation through graincards.
;;
;; What's φ (phi)? It's 1.618..., the golden ratio!
;; It's the most beautiful number in mathematics because it creates
;; perfect self-similarity at every scale. Nature uses it everywhere:
;; - Sunflower seeds spiral at the golden angle (137.5077°)
;; - Nautilus shells grow in golden spirals
;; - Galaxy arms follow φ proportions
;; - Water molecules bond at φ angles (Wheeler's discovery!)
;;
;; Our graincards use φ to create infinite fractal depth!
;; Each tap zooms in by factor of φ and rotates by the golden angle.
;;
;; Does this make sense? Let's build it step by step! 🌾

(require-builtin steel/math)

;; ============================================================================
;; 📐 FUNDAMENTAL CONSTANTS (The Sacred Geometry!)
;; ============================================================================

;; φ (PHI) - The Golden Ratio
;; This is (1 + √5) / 2 ≈ 1.618033988749894...
;;
;; Why is φ special? Because it's INCOMMENSURABLE - it can never
;; be expressed as a fraction! It's the "most irrational" number.
;; This creates maximum packing efficiency in nature!
;;
;; Think of it like this: If you have a golden rectangle and you
;; remove a square from it, what's left is ANOTHER golden rectangle!
;; This property creates infinite self-similarity! 🌀
(define PHI 1.618033988749894848204586834365638117720309179805762862135)

;; φ² (PHI-SQUARED) = φ + 1
;; This is another magical property of φ!
;; φ² = φ + 1 = 2.618033988...
;;
;; You can verify this: 1.618² ≈ 2.618
;; And: 1.618 + 1 = 2.618 ✓
;;
;; This means φ is the solution to: x² = x + 1
;; It's a geometric AND algebraic constant! 📐
(define PHI-SQUARED 2.618033988749894848204586834365638117720309179805762862135)

;; φ³ (PHI-CUBED) = 2φ + 1 (Wheeler's Hyperboloid Depth!)
;; φ³ = 4.236067977499789...
;;
;; Ken Wheeler discovered that magnetic vortices don't just follow φ,
;; they follow φ³! This creates the "hyperboloid" shape - like a
;; whirlpool that accelerates as it approaches the center!
;;
;; The deeper you go into the vortex, the faster the convergence.
;; This is the dielectric inertial plane pulling everything inward! ⚡
(define PHI-CUBED 4.236067977499789696409173668731276235440618359611525724270)

;; 1/φ (PHI-INVERSE) = φ - 1
;; 1/φ = 0.618033988...
;;
;; This is the "little phi" - the reciprocal of φ!
;; It appears when you subdivide by the golden ratio.
;; Each level is 0.618 (61.8%) of the previous level! 🌊
(define PHI-INVERSE 0.618033988749894848204586834365638117720309179805762862135)

;; GOLDEN ANGLE = 360° / φ² = 137.5077640500378...°
;;
;; This is THE most important angle in nature!
;; It's 360° divided by φ².
;;
;; Why does nature use this angle?
;; - Sunflower seeds: Pack most efficiently at 137.5°!
;; - Pinecone scales: Spiral at 137.5°!
;; - Rose petals: Arrange at 137.5°!
;; - Galaxy arms: Spiral at 137.5°!
;;
;; Each tap on our grainsite rotates by this magic angle! 🌻
(define GOLDEN-ANGLE 137.50776405003785240551127952721798273722839641304382073387)

;; ============================================================================
;; 🌀 PHI-SUBDIVISION FUNCTIONS (Spiraling Inward!)
;; ============================================================================

;; Calculate size at φ-level n
;; Formula: size ÷ φⁿ
;;
;; This is how we zoom in! Each tap divides the size by φ.
;;
;; Example: Starting with 100 characters wide:
;; - Level 0: 100.000 ÷ φ⁰ = 100.000 (full width)
;; - Level 1: 100.000 ÷ φ¹ = 61.803 (zoomed in!)
;; - Level 2: 100.000 ÷ φ² = 38.197
;; - Level 3: 100.000 ÷ φ³ = 23.607
;; - Level 4: 100.000 ÷ φ⁴ = 14.589
;; - Level 5: 100.000 ÷ φ⁵ = 9.017 (SEED!)
;;
;; See how each level is ~61.8% of the previous? That's φ at work! ⚡
(define (phi-subdivision-at-level size level)
  (/ size (expt PHI level)))

;; Calculate vortex DEPTH using Wheeler's φ³ hyperboloid!
;; Formula: size ÷ (φ³)ⁿ
;;
;; This is DIFFERENT from simple φ-subdivision!
;; The φ³ creates accelerated convergence - like water speeding up
;; as it approaches the drain! 🌊
;;
;; Example: Starting with 100 units:
;; - Level 0: 100.000 ÷ (φ³)⁰ = 100.000
;; - Level 1: 100.000 ÷ (φ³)¹ = 23.607 (4.2× faster!)
;; - Level 2: 100.000 ÷ (φ³)² = 5.573
;; - Level 3: 100.000 ÷ (φ³)³ = 1.316
;; - Level 4: 100.000 ÷ (φ³)⁴ = 0.311
;; - Level 5: 100.000 ÷ (φ³)⁵ = 0.073 (Nearly at center!)
;;
;; This is the DIELECTRIC INERTIAL PLANE pulling you inward! ⚡
(define (vortex-depth-at-level size level)
  (/ size (expt PHI-CUBED level)))

;; Calculate rotation angle at level n
;; Formula: GOLDEN-ANGLE × n (mod 360°)
;;
;; Each tap rotates by 137.5077°! This creates the spiral!
;;
;; Let's see what happens after each tap:
;; - Level 0: 0° (start)
;; - Level 1: 137.508° (first rotation)
;; - Level 2: 275.015° (almost full circle!)
;; - Level 3: 412.523° = 52.523° (wrapped around once)
;; - Level 4: 550.031° = 190.031° (wrapped around again)
;; - Level 5: 687.539° = 327.539° (almost back to start!)
;;
;; After 12 taps: 137.508° × 12 = 1650.09° = 210.09° net
;; You've spiraled around 4.58 times! This is the Fibonacci spiral! 🌻
(define (rotation-at-level level)
  (modulo (* GOLDEN-ANGLE level) 360.0))

;; ============================================================================
;; 📊 PHI-COORDINATE GENERATION (The Complete Vortex Map!)
;; ============================================================================

;; Generate complete φ-coordinates for a given rectangle
;; Returns a list of hashes, one for each level (0 to max-level)
;;
;; Each hash contains:
;; - level: Which φ-level (0 = full, 5 = seed)
;; - x, y: Position of the φ-point (where to tap!)
;; - width, height: Size of content at this zoom
;; - scale: How much to scale (1.0 = full, 0.09 = seed)
;; - rotation: Rotation angle in degrees
;; - vortex-depth: Hyperboloid depth (φ³ decay)
;;
;; This creates a complete "map" of the φ-vortex!
;; Svelte will use this to animate the spiral navigation! 🗺️
(define (generate-phi-coordinates width height max-level)
  (transduce
    (mapping
      (lambda (level)
        (let ([scale (/ 1.0 (expt PHI level))]
              [depth (vortex-depth-at-level (min width height) level)])
          (hash
            "level" level
            "x" (* width scale)
            "y" (* height scale)
            "width" (* width scale)
            "height" (* height scale)
            "scale" scale
            "rotation" (rotation-at-level level)
            "vortex_depth" depth))))
    (into-list)
    (range 0 (+ max-level 1))))

;; ============================================================================
;; 📝 GRAINCARD SECTION PARSING (Splitting into 12 Vortices!)
;; ============================================================================

;; Split graincard content into 12 sections (4×3 grid)
;;
;; A 100×75 graincard divides into:
;; - 4 columns (each 25 chars wide)
;; - 3 rows (each 25 lines tall)
;; = 12 sections total!
;;
;; But remember: these "25×25 squares" are ILLUSIONS (maya)!
;; They're actually toroidal φ-vortices that APPEAR square
;; in Euclidean projection! ⚡🧲
;;
;; Each section becomes its own φ-spiral when tapped!
(define (split-graincard-into-sections content)
  ;; Read the content line by line
  (let ([lines (string-split content "\n")])
    ;; Group into 3 rows of 25 lines each
    (let ([row1 (take lines 25)]
          [row2 (take (drop lines 25) 25)]
          [row3 (take (drop lines 50) 25)])
      ;; For each row, split into 4 columns of 25 chars each
      (flatten
        (list
          (split-row-into-4-columns row1)
          (split-row-into-4-columns row2)
          (split-row-into-4-columns row3))))))

;; Helper: Split a row (25 lines) into 4 columns
(define (split-row-into-4-columns lines)
  (map
    (lambda (col-index)
      (let ([start (* col-index 25)]
            [end (* (+ col-index 1) 25)])
        ;; Extract characters [start:end] from each line
        (string-join
          (map
            (lambda (line)
              (substring line start end))
            lines)
          "\n")))
    (list 0 1 2 3)))

;; ============================================================================
;; 🎯 MAIN GRAINCARD PROCESSOR (The Complete Pipeline!)
;; ============================================================================

;; Process a graincard into φ-vortex data structure
;;
;; Takes: graincard markdown content (string)
;; Returns: hash with complete φ-vortex structure
;;
;; This is the MAIN function that ties everything together!
;; It parses the graincard, calculates φ-coordinates for each section,
;; and returns a complete data structure ready for Svelte! 🌀
(define (process-graincard-to-phi-vortex content)
  (let ([sections (split-graincard-into-sections content)])
    (hash
      "format" "phi-vortex-graincard"
      "version" "1.0"
      "phi" PHI
      "phi_cubed" PHI-CUBED
      "golden_angle" GOLDEN-ANGLE
      "dimensions" (hash
        "width" 100
        "height" 75
        "sections" 12
        "section_width" 25
        "section_height" 25)
      "sections" (map-with-index
        (lambda (section index)
          (hash
            "index" index
            "content" section
            "phi_coords" (generate-phi-coordinates 25 25 5)))
        sections))))

;; Helper: map with index
(define (map-with-index f lst)
  (map f lst (range 0 (length lst))))

;; ============================================================================
;; 💾 JSON EXPORT (For Svelte Frontend!)
;; ============================================================================

;; Export φ-vortex data as JSON string
;;
;; Svelte can't read Steel directly, so we serialize to JSON!
;; This creates a .json file that Svelte loads at runtime.
;;
;; The JSON contains ALL the φ-math pre-calculated,
;; so Svelte just animates - it doesn't need to know the physics! ⚡
(define (export-phi-vortex-as-json graincard-content)
  (let ([phi-data (process-graincard-to-phi-vortex graincard-content)])
    (json-stringify phi-data)))

;; ============================================================================
;; 🔧 COMMAND-LINE INTERFACE (Build Tool!)
;; ============================================================================

;; Main entry point for building φ-vortex graincards
;;
;; Usage:
;;   steel grain-phi-vortex.scm input.md output.json
;;
;; This reads a graincard markdown file, processes it through
;; the φ-vortex calculator, and writes the JSON for Svelte! 🌾
(define (main args)
  (if (< (length args) 3)
      (begin
        (displayln "Usage: steel grain-phi-vortex.scm <input.md> <output.json>")
        (displayln "")
        (displayln "Example:")
        (displayln "  steel grain-phi-vortex.scm graincard.md phi-data.json")
        (displayln "")
        (displayln "This processes a 100×75 graincard into φ-vortex coordinates")
        (displayln "following Ken Wheeler's φ³ hyperboloid model! 🌀⚡")
        (exit 1))
      (let ([input-file (list-ref args 1)]
            [output-file (list-ref args 2)])
        (displayln (string-append "🌀 Processing: " input-file))
        (let ([content (read-file-to-string input-file)])
          (displayln "⚡ Calculating φ-coordinates...")
          (let ([json (export-phi-vortex-as-json content)])
            (displayln (string-append "💾 Writing: " output-file))
            (write-file output-file json)
            (displayln "✨ Done! φ-vortex data ready for Svelte!")
            (displayln "")
            (displayln (string-append "φ = " (number->string PHI)))
            (displayln (string-append "φ³ = " (number->string PHI-CUBED)))
            (displayln (string-append "Golden Angle = " (number->string GOLDEN-ANGLE) "°"))
            (displayln "")
            (displayln "now == next + 1 🌾⚡🌊✨"))))))

;; Run main if this file is executed directly
(when (= (length (command-line)) 3)
  (main (command-line)))

;; ============================================================================
;; 📚 MODULE EXPORTS
;; ============================================================================

;; Export public API for other Steel modules
(provide
  PHI
  PHI-SQUARED
  PHI-CUBED
  PHI-INVERSE
  GOLDEN-ANGLE
  phi-subdivision-at-level
  vortex-depth-at-level
  rotation-at-level
  generate-phi-coordinates
  process-graincard-to-phi-vortex
  export-phi-vortex-as-json)

;; ============================================================================
;; 🌟 YOU MADE IT TO THE END!
;; ============================================================================
;;
;; This module calculates the complete φ-vortex geometry for graincards!
;;
;; The key insights:
;; 1. φ (1.618...) creates perfect self-similarity
;; 2. φ³ (4.236...) governs vortex depth (Wheeler's hyperboloid)
;; 3. 137.5077° (golden angle) creates optimal spiral rotation
;; 4. Each 25×25 "square" is actually a toroidal φ-vortex!
;;
;; When users tap, they spiral inward through these φ-levels,
;; following the same geometry that sunflowers, galaxies,
;; and water vortices use!
;;
;; Does this all make sense? The math is beautiful, and now
;; we've encoded it in Steel! Next: Svelte will animate it! 🌀✨
;;
;; Questions? The Glow G2 voice is here to help! 🌾

