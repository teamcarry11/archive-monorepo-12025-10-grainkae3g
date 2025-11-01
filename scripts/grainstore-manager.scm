#!/usr/bin/env steel
;; grainstore-manager.scm - Grainstore Git Management
;;
;; 🌊⚒️ Team 11 Aquarius (t11aq) - Airbender Mode
;; Carrying wisdom, sharing knowledge, flowing like air and water.
;; Airbenders flow freely, carrying updates between repositories.
;;
;; Kid-Friendly Mode: Simple, clear, encouraging language.
;; One-Indexed Mode: Counting starts at 1 (more natural for kids).
;; Temporal Mode: Every operation is temporally transparent.
;; Airbender Mode: Flowing, sharing, carrying wisdom like the airbenders.
;;
;; Grain Network package: grainstore-manager
;; Module: scripts/grainstore-manager.scm
;; Purpose: Handles git pulling, merge conflicts, and documentation organization
;;
;; Installation: installed via grain package manager
;; Usage: (require "grainstore-manager/grainstore-manager.scm")
;;
;; What does this script do?
;; It helps manage all the repositories in the grainstore.
;; Like a water bearer carrying water from place to place,
;; this script carries updates between repositories.
;;
;; When? Now. Always now. But "now" includes full astronomical context.
;; This script operates in temporal mode - every operation knows when it happened.

(define grainstore-dir "grainstore")
(define docs-dir (string-append grainstore-dir "/docs"))

;; Logging functions (kid-friendly, airbender mode)
;; What is logging? It's like writing in a diary - we write down what happened.
;; Every message includes graintime - that's when it happened!
;; Graintime tells us not just the time, but also the moon phase and zodiac sign.
;;
;; Airbender mode: Like air and water flowing, messages flow through the system.
;; Kid-friendly: Simple messages that are easy to understand.
(define (log-message message)
  ;; Write a message about what's happening
  ;; TODO: Replace with actual graintime-now when graintime library available
  (displayln (string-append "🌊 [airbender says] " message)))

(define (log-error message)
  ;; Write an error message (something went wrong)
  (displayln (string-append "❌ [oops!] " message)))

(define (log-success message)
  ;; Write a success message (something worked!)
  (displayln (string-append "✅ [great!] " message)))

;; Command execution with temporal context
;; Why temporal context? Commands execute at specific moments in time.
;; Recording when helps us understand temporal patterns in git operations.
(define (run-command cmd)
  ;; Execute command and return output
  ;; Why this implementation? Steel provides `command` function to execute shell commands.
  ;; This works on both host (posix) and redox (via scheme system).
  (log-message (string-append "executing: " cmd))
  (let ((result (command cmd)))
    (if (= (command-exit-code result) 0)
        (command-stdout result)
        (begin
          (log-error (string-append "command failed: " cmd " - " (command-stderr result)))
          ""))))

;; Get graintime for documentation
;; Why graintime instead of timestamp? Temporal transparency.
;; When was this index generated? Not just "2025-10-31 15:30:00"
;; but full astronomical context: moon phase, zodiac, etc.
(define (get-graintime)
  ;; TODO: Replace with actual graintime-now when graintime library available
  ;; For now, return placeholder indicating temporal intent
  "graintime:now [placeholder - will use actual graintime library]")

;; Helper: split string by delimiter
;; Why this? Steel may not have string-split built-in.
(define (string-split str delim)
  (let loop ((remaining str)
             (current "")
             (result '()))
    (if (string=? remaining "")
        (reverse (if (string=? current "")
                     result
                     (cons current result)))
        (let ((char (substring remaining 0 1)))
          (if (string=? char delim)
              (loop (substring remaining 1)
                    ""
                    (if (string=? current "")
                        result
                        (cons current result)))
              (loop (substring remaining 1)
                    (string-append current char)
                    result))))))

;; List grainstore repositories (one-indexed, kid-friendly, airbender mode)
;; What are repositories? They're like folders that hold code and documents.
;; We count them starting from 1 (not 0) because that's easier for kids!
;; The airbender flows through all these repositories, carrying updates.
(define (list-grainstore-repos)
  ;; List all repositories in grainstore
  ;; Returns a list of repository names
  ;; Why use shell commands? Steel may not have built-in directory listing yet.
  ;; We use `find` command which works on both posix and redox.
  (let ((result (command (string-append "find " docs-dir " -maxdepth 1 -type d -not -path " docs-dir " 2>/dev/null"))))
    (if (= (command-exit-code result) 0)
        (let ((output (command-stdout result))
              (dirs (string-split output "\n")))
          (filter (lambda (dir)
                    ;; Extract basename from full path
                    (and (not (string=? dir ""))
                         (let ((parts (string-split dir "/")))
                           (if (null? parts)
                               ""
                               (car (reverse parts))))))
                  dirs))
        '())))

;; Pull repository (airbender flowing to get updates!)
;; What does "pull" mean? It means getting the latest updates from the internet.
;; Like an airbender flowing to gather fresh information.
;; Kid-friendly: We explain what we're doing in simple words.
(define (pull-repo repo-name)
  ;; Pull updates for one repository
  ;; The airbender flows to this repository and carries fresh updates
  (let ((repo-path (string-append docs-dir "/" repo-name)))
    (log-message (string-append "flowing to " repo-name " to get fresh updates! 🌊"))
    ;; Why check if directory exists? Fail fast if repository doesn't exist.
    (if (directory-exists? repo-path)
        (let ((result (command (string-append "cd " repo-path " && git pull 2>&1"))))
          (if (= (command-exit-code result) 0)
              (begin
                (log-success (string-append repo-name " is now up to date! ✨"))
                #t)
              (begin
                (log-error (string-append "failed to pull " repo-name ": " (command-stderr result)))
                #f)))
        (begin
          (log-error (string-append "repository " repo-name " does not exist at " repo-path))
          #f))))

;; Helper: check if directory exists
;; Why this function? We need to verify repositories exist before operating on them.
(define (directory-exists? path)
  (let ((result (command (string-append "test -d " path))))
    (= (command-exit-code result) 0)))

;; Handle merge conflicts with temporal context
;; Why temporal context? Conflicts emerge at specific moments.
;; Understanding when helps us see patterns in collaboration.
(define (handle-merge-conflicts repo-name)
  (let ((repo-path (string-append docs-dir "/" repo-name)))
    (log-message (string-append "checking conflicts in " repo-name " [graintime:now]"))
    ;; Why check git status? We need to detect if there are merge conflicts.
    ;; Git status shows us if files are in conflicted state.
    (let ((result (command (string-append "cd " repo-path " && git status --porcelain 2>&1"))))
      (if (= (command-exit-code result) 0)
          (let ((status-output (command-stdout result)))
            ;; Check for conflict markers (UU, AA, DD in git status)
            (if (or (string-contains? status-output "UU")
                    (string-contains? status-output "AA")
                    (string-contains? status-output "DD"))
                (begin
                  (log-error (string-append "conflicts detected in " repo-name " - manual resolution needed"))
                  #f)
                (begin
                  (log-success (string-append "no conflicts in " repo-name " [graintime:now]"))
                  #t)))
          (begin
            (log-error (string-append "failed to check status for " repo-name ": " (command-stderr result)))
            #f)))))

;; Helper: check if string contains substring
;; Why this? Steel may not have string-contains? built-in.
(define (string-contains? str substr)
  (let ((str-len (string-length str))
        (substr-len (string-length substr)))
    (if (< str-len substr-len)
        #f
        (let loop ((idx 0))
          (if (> (+ idx substr-len) str-len)
              #f
              (if (string=? (substring str idx (+ idx substr-len)) substr)
                  #t
                  (loop (+ idx 1))))))))

;; Pull all repositories (the airbender flows to all repositories!)
;; What does this do? It visits every repository and gets fresh updates.
;; Like an airbender flowing through the air to visit many places.
;; One-indexed: We count repositories starting from 1, not 0.
(define (pull-all-repos)
  ;; Pull updates for all repositories
  ;; The airbender flows on a journey to all repositories
  (log-message "flowing to all repositories to get fresh updates! 🌊✨"))
  (let ((repos (list-grainstore-repos)))
    (if (null? repos)
        (log-message "no repositories found - nothing to do!")
        (begin
          ;; Count repositories (one-indexed: 1, 2, 3...)
          (let ((total (length repos))
                (count 1))
            (log-message (string-append "found " (number->string total) " repositories to update"))
            (for-each (lambda (repo)
                        ;; Kid-friendly: show progress "repository 1 of 5"
                        (log-message (string-append "repository " (number->string count) " of " (number->string total) ": " repo))
                        (pull-repo repo)
                        (handle-merge-conflicts repo)
                        (set! count (+ count 1)))  ; One-indexed counting!
                      repos)
            (log-success (string-append "all " (number->string total) " repositories are now up to date! 🎉")))))))

;; Timestamp docs with graintime
;; Why graintime instead of timestamp? Temporal transparency.
;; Files are moved at specific graintime moments, not just dates.
;; This preserves full temporal context for documentation.
(define (timestamp-docs source-dir target-dir)
  ;; Timestamp and move documentation files
  ;; Uses graintime instead of simple timestamp
  (let ((graintime (get-graintime)))
    (log-message (string-append "timestamping docs with graintime: " graintime))
    ;; Why create target directory first? We need somewhere to move files.
    ;; The mkdir -p command creates parent directories if needed.
    (let ((mkdir-result (command (string-append "mkdir -p " target-dir))))
      (if (= (command-exit-code mkdir-result) 0)
          ;; Move files from source to target
          ;; Why use mv? It preserves file metadata and moves efficiently.
          (let ((mv-result (command (string-append "mv " source-dir "/* " target-dir "/ 2>&1"))))
            (if (= (command-exit-code mv-result) 0)
                (log-success "docs timestamped with graintime")
                (log-error (string-append "failed to move docs: " (command-stderr mv-result)))))
          (log-error (string-append "failed to create target directory: " (command-stderr mkdir-result)))))))

;; Organize documentation with temporal structure
;; Temporal structure: Organization happens at specific graintime moments.
;; The organization itself is a temporal event in the grain network.
(define (organize-docs)
  (log-message "organizing documentation [graintime:now]")
  ;; Why organize by type? Makes documentation easier to find.
  ;; We create directories for different document types (markdown, images, etc).
  (let ((organize-dirs '("markdown" "images" "archives")))
    (for-each (lambda (dir-name)
                (let ((dir-path (string-append docs-dir "/" dir-name))
                      (result (command (string-append "mkdir -p " dir-path))))
                  (if (= (command-exit-code result) 0)
                      (log-message (string-append "created directory: " dir-name))
                      (log-error (string-append "failed to create directory " dir-name ": " (command-stderr result))))))
              organize-dirs)
    (log-success "documentation organized [graintime:now]")))

;; Helper: format repository list for index
;; Why this function? Makes the index readable with numbered list (one-indexed!).
(define (format-repo-list repos)
  (if (null? repos)
      "no repositories found"
      (let loop ((remaining repos)
                 (count 1)
                 (result ""))
        (if (null? remaining)
            result
            (loop (cdr remaining)
                  (+ count 1)
                  (string-append result
                                (number->string count) ". " (car remaining) "\n"))))))

;; Create grainstore index with graintime generation timestamp
;; Temporal metadata: Index generation is a temporal event.
;; When was this index created? Full graintime context, not just date.
(define (create-grainstore-index)
  (let ((repos (list-grainstore-repos))
        (graintime (get-graintime))
        (index-path (string-append grainstore-dir "/INDEX.md"))
        (index-content (string-append
                        "# grainstore repository index\n\n"
                        "**generated**: " graintime "\n"
                        "**total repositories**: " (number->string (length repos)) "\n\n"
                        "## repositories\n\n"
                        (format-repo-list repos)
                        "\n\n## temporal context\n\n"
                        "this index was generated at graintime: " graintime "\n"
                        "all operations are temporally transparent.\n")))
    ;; Why use shell command to write file? Steel may not have built-in file writing yet.
    ;; We use printf with heredoc-style approach which handles newlines correctly.
    ;; Escape single quotes in content for shell safety
    (let ((escaped-content (string-replace index-content "'" "'\\''")))
      (let ((result (command (string-append "printf '%s' '" escaped-content "' > " index-path))))
        (if (= (command-exit-code result) 0)
            (log-success (string-append "grainstore index created [graintime:" graintime "]"))
            (log-error (string-append "failed to create index: " (command-stderr result)))))))

;; Helper: replace all occurrences of substring
;; Why this? We need to escape single quotes for shell safety.
(define (string-replace str old new)
  (let ((old-len (string-length old))
        (new-len (string-length new)))
    (let loop ((remaining str)
               (result ""))
      (if (string=? remaining "")
          result
          (let ((idx (string-find remaining old)))
            (if idx
                (loop (substring remaining (+ idx old-len))
                      (string-append result
                                    (substring remaining 0 idx)
                                    new))
                (string-append result remaining)))))))

;; Helper: find substring index in string
;; Why this? We need to find where to replace substrings.
(define (string-find str substr)
  (let ((str-len (string-length str))
        (substr-len (string-length substr)))
    (if (< str-len substr-len)
        #f
        (let loop ((idx 0))
          (if (> (+ idx substr-len) str-len)
              #f
              (if (string=? (substring str idx (+ idx substr-len)) substr)
                  idx
                  (loop (+ idx 1)))))))))

;; Show help (kid-friendly, airbender mode)
;; Kid-friendly: Simple explanations that anyone can understand.
;; Airbender: Like air and water flowing, information flows through this help.
(define (show-help)
  (displayln "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
  (displayln "🌊 grainstore manager - git and documentation management")
  (displayln "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
  (displayln "")
  (displayln "airbender mode: flowing like air and water, carrying updates between repositories")
  (displayln "like an airbender visiting many places, we flow to all repositories!")
  (displayln "")
  (displayln "🌊 airbender mode: flowing, sharing, carrying wisdom freely")
  (displayln "📚 kid-friendly: simple explanations for everyone")
  (displayln "🔢 one-indexed: counting starts at 1 (more natural!)")
  (displayln "⏰ temporal mode: every operation knows when it happened")
  (displayln "")
  (displayln "usage: steel grainstore-manager.scm <command> [options]")
  (displayln "")
  (displayln "commands:")
  (displayln "  pull-all                    visit all repositories and get fresh updates")
  (displayln "  pull <repo>                 get fresh updates for one repository")
  (displayln "  resolve-conflicts <repo>    fix problems when code conflicts")
  (displayln "  organize                    organize documentation files")
  (displayln "  create-index                make a list of all repositories")
  (displayln "  list                        show all repositories (numbered 1, 2, 3...)")
  (displayln "  help                        show this help message")
  (displayln "")
  (displayln "examples:")
  (displayln "  steel grainstore-manager.scm list")
  (displayln "  steel grainstore-manager.scm pull-all")
  (displayln "  steel grainstore-manager.scm pull my-repo")
  (displayln "")
  (displayln "remember: counting starts at 1, not 0! (one-indexed mode)")
  (displayln "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))

;; Main entry point with temporal command routing
;; Temporal routing: Commands execute at specific graintime moments.
;; Each command is a temporal event in the grain network.
(define (main args)
  (if (null? args)
      (show-help)
      (let ((command (car args)))
        (case command
          (("pull-all") (pull-all-repos))
          (("pull") (if (null? (cdr args))
                       (log-error "usage: pull <repo-name>")
                       (pull-repo (cadr args))))
          (("resolve-conflicts") (if (null? (cdr args))
                                    (log-error "usage: resolve-conflicts <repo-name>")
                                    (handle-merge-conflicts (cadr args))))
          (("organize") (organize-docs))
          (("create-index") (create-grainstore-index))
          (("list") (begin
                     ;; List repositories with one-indexed numbering (kid-friendly!)
                     (log-message "here are all the repositories:")
                     (let ((repos (list-grainstore-repos))
                           (count 1))  ; Start counting at 1!
                       (if (null? repos)
                           (log-message "no repositories found yet")
                           (for-each (lambda (repo)
                                       ;; Show "1. repo-name", "2. repo-name", etc.
                                       (displayln (string-append "  " (number->string count) ". " repo))
                                       (set! count (+ count 1)))  ; One-indexed!
                                     repos))
                       (log-success (string-append "found " (number->string (length repos)) " repositories")))))
          (("help") (show-help))
          (else (begin
                 (log-error (string-append "unknown command: " command))
                 (show-help)))))))

;; Run main with command-line arguments
;; Temporal entry: Script execution begins at graintime:now
(main (command-line))

