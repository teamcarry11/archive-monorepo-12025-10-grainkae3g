#!/usr/bin/env steel
;; grainmirror-carry11.scm - Sync teamkae3gtransform08 files to teamkae3gcarry11 grainstore
;; 
;; Automatically syncs markdown files from teamkae3gtransform08 repo to teamkae3gcarry11 grainstore
;; 
;; 🌊⚒️ The Water Bearer - Carrying wisdom, sharing knowledge, pouring between vessels.
;; Written in Steel Lisp (Scheme R5RS) for Grain Network
;;
;; Why Steel instead of Babashka?
;; Steel is the unified scripting language for Grain Network.
;; This aligns with our philosophy: one language for everything.
;; Steel runs natively on Redox OS, compiles to WASM for ICP,
;; and provides the same memory safety as Rust.
;;
;; Does this make sense? We're building infrastructure that works
;; across all Grain Network platforms: Redox, Linux, ICP canisters.
;; Steel gives us that portability.

;; Dependencies
;; We'll use Steel's built-in file operations and process execution
;; Steel provides: file operations, directory listing, process spawning
;; Why built-ins? Steel is designed to be self-contained for system scripts

(define source-dir "/home/xy/github/kae3g/teamkae3gtransform08")
(define target-dir "/home/xy/kae3g/grainkae3g/grainstore/kae3g/teamkae3gcarry11")

;; Graintime logging
;; Why graintime? Every operation should be temporally transparent.
;; When did this sync happen? Graintime tells us exactly when,
;; with astronomical context, timezone, and zodiacal information.
;;
;; For now, we'll use a simple timestamp. In full Grain Network,
;; we'd call (graintime-now) to get a full graintime value.
(define (log-message message)
  ;; Why displayln instead of display + newline?
  ;; Steel provides displayln for convenience - it's like println in other languages.
  ;; This reduces boilerplate and makes logs cleaner.
  (displayln (string-append "🌊 [grainmirror-carry11] " message)))

(define (log-error message)
  ;; Why separate error logging?
  ;; Errors need different handling than info logs.
  ;; We might want to send errors to different destinations,
  ;; add stack traces, or trigger alerts.
  (displayln (string-append "❌ [grainmirror-carry11 ERROR] " message)))

;; File operations
;; Why these functions? Steel uses shell commands for file operations.
;; Steel provides the `command` function to execute shell commands.
;; This approach works on both host (posix) and redox (via scheme system).
(define (file-exists? path)
  ;; Check if file exists using shell test command
  ;; Why shell command? Steel doesn't have built-in file operations yet.
  ;; We use shell commands that work on both posix and redox.
  (let ((result (command (string-append "test -f " path))))
    (= (command-exit-code result) 0)))

(define (directory-exists? path)
  ;; Check if directory exists using shell test command
  ;; Why separate from file-exists? Directories are different from files.
  ;; Some systems treat them differently (permissions, etc).
  (let ((result (command (string-append "test -d " path))))
    (= (command-exit-code result) 0)))

(define (copy-file source target)
  ;; Copy a file from source to target using shell cp command
  ;; Why this function? Abstracts the copy operation.
  ;; In the future, we might want to add:
  ;; - Progress reporting
  ;; - Checksum verification
  ;; - Atomic copies (copy to temp, then rename)
  ;; This function gives us a place to add those features.
  (if (file-exists? source)
      (begin
        ;; Use shell cp command
        ;; On host: uses posix cp
        ;; On redox: uses file:// scheme via cp command
        (let ((result (command (string-append "cp " source " " target))))
          (if (= (command-exit-code result) 0)
              #t
              (begin
                (log-error (string-append "Failed to copy file: " (command-stderr result)))
                #f))))
      (begin
        (log-error (string-append "Source file does not exist: " source))
        #f)))

(define (list-markdown-files dir)
  ;; List all .md files in a directory using shell find command
  ;; Why filter for .md? We only want markdown files.
  ;; Other files might be temporary, build artifacts, or unrelated.
  ;; Filtering here keeps the sync focused.
  (let ((result (command (string-append "find " dir " -maxdepth 1 -name '*.md' -type f"))))
    (if (= (command-exit-code result) 0)
        ;; Parse output into list of filenames (basename only)
        (let ((output (command-stdout result))
              (files (string-split output "\n")))
          (filter (lambda (file)
                    ;; Extract basename from full path
                    (let ((parts (string-split file "/")))
                      (if (null? parts)
                          ""
                          (car (reverse parts)))))
                  files))
        '())))

;; Sync logic
;; Why this structure? We separate concerns:
;; 1. List files (reading)
;; 2. Copy files (writing)
;; 3. Log results (observability)
;; This makes the code easier to test and understand.
(define (sync-files)
  ;; Main sync function
  ;; Why this name? "sync" is clearer than "copy" - it implies
  ;; bidirectional or state synchronization, even though we're
  ;; currently doing one-way copy. Future versions might sync both ways.
  (log-message "Starting sync: teamkae3gtransform08 → teamkae3gcarry11 grainstore")
  
  ;; Check source directory exists
  ;; Why check first? Fail fast. If source doesn't exist,
  ;; we know immediately instead of discovering it later.
  (if (not (directory-exists? source-dir))
      (begin
        (log-error (string-append "Source directory does not exist: " source-dir))
        #f)
      ;; Check target directory exists
      ;; Why check target? We need somewhere to copy files.
      ;; If it doesn't exist, we could create it, but for now
      ;; we'll require it to exist (fail fast for misconfiguration).
      (if (not (directory-exists? target-dir))
          (begin
            (log-error (string-append "Target directory does not exist: " target-dir))
            #f)
          ;; Both directories exist, proceed with sync
          (let ((files (list-markdown-files source-dir))
                (copied 0)
                (failed 0))
            ;; Why count copied/failed? Metrics help us understand
            ;; what's happening. How many files synced? Any failures?
            ;; This data helps debug issues and monitor health.
            (for-each (lambda (file)
                        (let ((source-path (string-append source-dir "/" file))
                              (target-path (string-append target-dir "/" file)))
                          ;; Why this structure? For each file, we:
                          ;; 1. Build source and target paths
                          ;; 2. Try to copy
                          ;; 3. Track success/failure
                          ;; This gives us visibility into the sync process.
                          (if (copy-file source-path target-path)
                              (set! copied (+ copied 1))
                              (set! failed (+ failed 1)))))
                      files)
            ;; Log results
            ;; Why log summary? Single number is easier to understand
            ;; than scrolling through 79 individual "copied" messages.
            ;; We still have the option to log each file if needed (debug mode).
            (log-message (string-append "Sync complete: " 
                                       (number->string copied) " copied, "
                                       (number->string failed) " failed"))
            (if (= failed 0)
                #t
                #f))))))

;; Main entry point
;; Why this structure? Checks command-line arguments to decide
;; whether to run once (sync) or as daemon (daemon).
;; This gives us flexibility: run manually or as service.
(define (main)
  (let ((args (command-line)))
    ;; Why check args? Different modes need different behavior.
    ;; "sync" = run once and exit
    ;; "daemon" = run forever in loop
    ;; No args = default to "sync" (safer for manual runs)
    (cond
     ((null? args)
      ;; No arguments, run once
      (sync-files))
     ((equal? (car args) "sync")
      ;; Explicit sync mode (same as no args)
      (sync-files))
     (else
      ;; Unknown argument
      (displayln "Usage: grainmirror-carry11.scm [sync]")
      #f))))

;; Run main
;; Why call main here? When script executes, start the main function.
;; This is standard Scheme pattern: define functions, then call main.
(main)

