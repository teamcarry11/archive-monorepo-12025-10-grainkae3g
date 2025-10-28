#!/usr/bin/env bb

;; ============================================================================
;; SET-GRAIN-URLS - grainSOURCE vs grainSITE Automation
;; ============================================================================
;; teamstructure10 (Capricorn ♑ / X. The Wheel of Fortune)
;; "Two URLs. One foundation. Perfect clarity."
;; ============================================================================

(require '[clojure.string :as str]
         '[clojure.java.shell :as shell])

;; ----------------------------------------------------------------------------
;; CORE CONCEPTS
;; ----------------------------------------------------------------------------
;; grainSOURCE = Source code tree (github.com/.../tree/BRANCH/)
;; grainSITE = Live rendered site (github.io/.../)
;; grainbranch = Branch name (the grainpath with graintime)
;; grainpath = Title + graintime (human-readable identifier)
;; ----------------------------------------------------------------------------

(defn run-cmd
  "Run shell command and return result"
  [& args]
  (let [result (apply shell/sh args)]
    {:success (zero? (:exit result))
     :output (str/trim (:out result))
     :error (str/trim (:err result))
     :exit (:exit result)}))

(defn get-current-branch
  "Get current git branch name"
  []
  (let [result (run-cmd "git" "branch" "--show-current")]
    (when (:success result)
      (:output result))))

(defn get-repo-info
  "Get repository owner and name"
  []
  (let [result (run-cmd "gh" "repo" "view" "--json" "nameWithOwner,owner" "--jq" ".nameWithOwner,.owner.login")]
    (when (:success result)
      (let [[name-with-owner owner] (str/split (:output result) #"\n")]
        {:full-name name-with-owner
         :owner owner
         :name (second (str/split name-with-owner #"/"))}))))

(defn check-pages-enabled
  "Check if GitHub Pages is enabled for repo"
  []
  (let [result (run-cmd "gh" "api" "repos/{owner}/{repo}/pages")]
    (and (:success result)
         (not (str/includes? (:error result) "404")))))

(defn generate-source-url
  "Generate grainSOURCE URL (source code tree)"
  [repo-info branch-name]
  (str "https://github.com/"
       (:full-name repo-info)
       "/tree/"
       branch-name
       "/"))

(defn generate-site-url
  "Generate grainSITE URL (live GitHub Pages)"
  [repo-info]
  (str "https://"
       (:owner repo-info)
       ".github.io/"
       (:name repo-info)
       "/"))

(defn set-upstream-tracking
  "Set upstream tracking for current branch"
  [branch-name]
  (println "\n📡 Setting origin upstream...")
  (let [result (run-cmd "git" "push" "--set-upstream" "origin" branch-name)]
    (if (:success result)
      (do
        (println "   ✓ Origin upstream: origin/" branch-name)
        true)
      (do
        (println "   ❌ Failed:")
        (println "     " (:error result))
        false))))

(defn set-github-default-branch
  "Set GitHub repository default branch"
  [branch-name]
  (println "\n🌐 Setting GitHub default branch...")
  (let [result (run-cmd "gh" "repo" "edit" "--default-branch" branch-name)]
    (if (:success result)
      (do
        (println "   ✓ GitHub default:" branch-name)
        true)
      (do
        (println "   ❌ Failed:")
        (println "     " (:error result))
        false))))

(defn update-github-about
  "Update GitHub About description"
  [description]
  (println "\n📝 Updating GitHub About...")
  (let [result (run-cmd "gh" "repo" "edit" "--description" description)]
    (if (:success result)
      (do
        (println "   ✓ About updated")
        (println "     " description)
        true)
      (do
        (println "   ❌ Failed:")
        (println "     " (:error result))
        false))))

(defn update-readme-urls
  "Update README.md with grainSOURCE and grainSITE URLs at top"
  [grain-source grain-site]
  (println "\n📄 Updating README URLs...")
  (let [readme-path "README.md"]
    (if (.exists (clojure.java.io/file readme-path))
      (let [content (slurp readme-path)
            ;; Look for existing URL section or add at top
            urls-section (str "**🌐 Live Site**: " grain-site "\n"
                            "**📦 Source**: " grain-source "\n\n"
                            "---\n\n")
            
            ;; If README starts with # title, insert after first line
            ;; Otherwise insert at very top
            updated (if (str/starts-with? content "#")
                     (let [lines (str/split-lines content)
                           title (first lines)
                           rest-lines (rest lines)]
                       (str title "\n\n" urls-section (str/join "\n" rest-lines)))
                     (str urls-section content))]
        
        (spit readme-path updated)
        (println "   ✓ README updated with URLs")
        true)
      (do
        (println "   ⚠️  README.md not found")
        false))))

(defn set-grain-urls
  "Complete grain URL setup: grainSOURCE + grainSITE
  
  Usage:
    bb set-grain-urls.bb              # Auto-detect, check Pages
    bb set-grain-urls.bb BRANCH       # Specific branch, check Pages
    bb set-grain-urls.bb BRANCH true  # Force Pages mode
    bb set-grain-urls.bb BRANCH false # Force no-Pages mode"
  
  ([]
   (if-let [branch (get-current-branch)]
     (set-grain-urls branch nil)
     (do
       (println "❌ Could not determine current branch")
       (System/exit 1))))
  
  ([branch-name]
   (set-grain-urls branch-name nil))
  
  ([branch-name force-pages]
   (println "\n🌾 Setting Grain URLs for:" branch-name)
   (println "═════════════════════════════════════════════\n")
   
   (let [repo-info (get-repo-info)
         _ (println "📦 Repository:" (:full-name repo-info))
         
         grain-source (generate-source-url repo-info branch-name)
         _ (println "📂 grainSOURCE:" grain-source)
         
         has-pages? (if (some? force-pages)
                     force-pages
                     (check-pages-enabled))
         
         grain-site (when has-pages?
                     (generate-site-url repo-info))
         
         _ (if grain-site
             (println "🌐 grainSITE:" grain-site)
             (println "📝 No GitHub Pages (grainSITE not available)"))
         
         ;; Decide what goes in GitHub About
         about-desc (if grain-site
                     (str "Live: " grain-site)
                     (str "Source: " grain-source))
         
         ;; Execute all updates
         upstream-ok? (set-upstream-tracking branch-name)
         default-ok? (set-github-default-branch branch-name)
         about-ok? (update-github-about about-desc)
         readme-ok? (when grain-site
                     (update-readme-urls grain-source grain-site))]
     
     (println "\n═════════════════════════════════════════════")
     (println "Summary:")
     (println "  Origin upstream:" (if upstream-ok? "✓" "✗"))
     (println "  GitHub default:" (if default-ok? "✓" "✗"))
     (println "  GitHub About:" (if about-ok? "✓" "✗"))
     (when grain-site
       (println "  README URLs:" (if readme-ok? "✓" "✗")))
     (println "═════════════════════════════════════════════")
     
     (println "\n📊 URL Configuration:")
     (println "  grainSOURCE →" grain-source)
     (when grain-site
       (println "  grainSITE   →" grain-site))
     (println "  GitHub About shows:" about-desc)
     
     (if (and upstream-ok? default-ok? about-ok?)
       (do
         (println "\n✅ Grain URLs configured perfectly!")
         (System/exit 0))
       (do
         (println "\n⚠️  Some steps failed - check above")
         (System/exit 1))))))

;; Main execution
(cond
  (= (count *command-line-args*) 0)
  (set-grain-urls)
  
  (= (count *command-line-args*) 1)
  (set-grain-urls (first *command-line-args*))
  
  (= (count *command-line-args*) 2)
  (set-grain-urls (first *command-line-args*)
                  (= (second *command-line-args*) "true"))
  
  :else
  (do
    (println "Usage: bb set-grain-urls.bb [BRANCH] [true|false]")
    (System/exit 1)))
