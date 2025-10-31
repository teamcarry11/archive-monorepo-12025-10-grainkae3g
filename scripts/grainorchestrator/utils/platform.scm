#!/usr/bin/env steel
;; platform.scm - platform abstraction layer
;;
;; grain network package: grainorchestrator
;; module: utils/platform.scm
;;
;; this module abstracts platform differences between:
;; - "host" mode: traditional posix systems (ubuntu, linux, macos)
;; - "redox" mode: redox os with url-based file system and scheme system
;;
;; package dependencies:
;; - grainplatform: shared platform abstraction utilities
;;
;; why abstraction? we want grainorchestrator to work on both platforms
;; without code duplication. macros and specs let us define platform-specific
;; implementations that compile to the right code for each platform.
;;
;; does this make sense? instead of if/else checks everywhere,
;; we use macros that expand to platform-specific code at compile time.
;; this keeps the code clean and efficient.
;;
;; installation: installed via grain package manager as part of
;; grainorchestrator package. platform detection happens automatically
;; at package install time based on the target system.

;; ============================================================================
;; platform detection
;; ============================================================================

;; detect current platform
;; why this function? we need to know which platform we're running on.
;; checks environment variables and system features to determine platform.
(define (detect-platform)
  ;; check for redox-specific environment variable
  (if (getenv "REDOX")
      ':redox
      ;; check for redox-specific features (future: check for scheme system)
      (if (feature? 'redox-schemes)
          ':redox
          ;; default to host (posix)
          ':host)))

;; current platform (computed once at module load)
;; why cache this? platform doesn't change during execution.
;; computing it once avoids repeated checks.
(define current-platform (detect-platform))

;; ============================================================================
;; platform modes
;; ============================================================================

;; platform mode spec
;; why this spec? defines valid platform modes.
;; ensures we only use supported platforms.
(define-spec platform-mode?
  (or ':host ':redox))

;; verify current platform is valid
;; why this check? fail fast if platform is unsupported.
(define (verify-platform)
  (if (not (platform-mode? current-platform))
      (error (string-append "unsupported platform: " (symbol->string current-platform)))
      #t))

;; ============================================================================
;; file operations abstraction
;; ============================================================================

;; file path abstraction
;; why this macro? converts paths to platform-specific format.
;; - host: traditional paths like "/var/lib/db"
;; - redox: file:// urls like "file:///var/lib/db"
(define-macro (file-path path)
  (match current-platform
    [':host
     ;; host mode: use path as-is
     `,path]
    [':redox
     ;; redox mode: convert to file:// url if not already
     (if (string-prefix? path "file://")
         `,path
         `(string-append "file://" ,path))]))

;; open file (platform-abstracted)
;; why this function? abstracts file opening for both platforms.
;; - host: use standard posix open()
;; - redox: use file:// url with scheme system
(define (platform-open-file path mode)
  (match current-platform
    [':host
     ;; host mode: posix open
     (open-file path mode)]
    [':redox
     ;; redox mode: file:// url via scheme system
     (let ([file-url (if (string-prefix? path "file://")
                         path
                         (string-append "file://" path))])
       (open-file-url file-url mode))]))

;; read file (platform-abstracted)
;; why this function? abstracts file reading.
(define (platform-read-file path)
  (let ([fd (platform-open-file path 'read)])
    (read-file-fd fd)))

;; write file (platform-abstracted)
;; why this function? abstracts file writing.
(define (platform-write-file path content)
  (let ([fd (platform-open-file path 'write)])
    (write-file-fd fd content)
    (close-file fd)))

;; ============================================================================
;; network operations abstraction
;; ============================================================================

;; network url abstraction
;; why this macro? converts network addresses to platform-specific format.
;; - host: traditional addresses like "localhost:9092"
;; - redox: tcp:// urls like "tcp://localhost:9092"
(define-macro (network-url host port)
  (match current-platform
    [':host
     ;; host mode: combine host:port
     `(string-append ,host ":" (number->string ,port))]
    [':redox
     ;; redox mode: tcp:// url
     `(string-append "tcp://" ,host ":" (number->string ,port))]))

;; connect to network service (platform-abstracted)
;; why this function? abstracts network connections.
;; - host: use posix sockets
;; - redox: use tcp:// url via scheme system
(define (platform-connect address)
  (match current-platform
    [':host
     ;; host mode: posix socket connect
     (socket-connect address)]
    [':redox
     ;; redox mode: tcp:// url via scheme system
     (let ([tcp-url (if (string-prefix? address "tcp://")
                        address
                        (string-append "tcp://" address))])
       (scheme-connect tcp-url))]))

;; ============================================================================
;; database operations abstraction
;; ============================================================================

;; database path abstraction
;; why this macro? converts db paths to platform-specific format.
;; - host: "/var/lib/grainorchestrator/state.db"
;; - redox: "file:///var/lib/grainorchestrator/state.db"
(define-macro (db-path path)
  (file-path path))

;; save database (platform-abstracted)
;; why this function? abstracts database persistence.
(define (platform-save-db db path)
  (let ([platform-path (db-path path)])
    (match current-platform
      [':host
       ;; host mode: direct file write
       (serialize-db-to-file db platform-path)]
      [':redox
       ;; redox mode: file:// url write
       (serialize-db-to-url db platform-path)])))

;; load database (platform-abstracted)
;; why this function? abstracts database loading.
(define (platform-load-db path)
  (let ([platform-path (db-path path)])
    (match current-platform
      [':host
       ;; host mode: direct file read
       (deserialize-db-from-file platform-path)]
      [':redox
       ;; redox mode: file:// url read
       (deserialize-db-from-url platform-path)])))

;; ============================================================================
;; event log abstraction
;; ============================================================================

;; event log url abstraction
;; why this macro? converts event log addresses to platform-specific format.
;; - host: "localhost:9092" or "/var/log/events.log"
;; - redox: "tcp://localhost:9092" or "file:///var/log/events.log"
(define-macro (event-log-url address)
  (match current-platform
    [':host
     ;; host mode: use address as-is (could be host:port or file path)
     `,address]
    [':redox
     ;; redox mode: add scheme prefix if missing
     (if (or (string-prefix? address "tcp://")
             (string-prefix? address "file://")
             (string-prefix? address "icp://"))
         `,address
         ;; guess scheme: if contains :, assume tcp://, else file://
         `(if (string-contains? ,address ":")
              (string-append "tcp://" ,address)
              (string-append "file://" ,address)))]))

;; connect to event log (platform-abstracted)
;; why this function? abstracts event log connections.
(define (platform-connect-event-log address)
  (let ([url (event-log-url address)])
    (match current-platform
      [':host
       ;; host mode: detect type from address
       (if (string-contains? address ":")
           ;; network address: use posix socket
           (connect-kafka-host address)
           ;; file path: use posix file
           (connect-file-log address))]
      [':redox
       ;; redox mode: use scheme system
       (if (string-prefix? url "tcp://")
           (connect-kafka-redox url)
           (if (string-prefix? url "file://")
               (connect-file-log-redox url)
               (if (string-prefix? url "icp://")
                   (connect-icp-redox url)
                   (error "unknown event log scheme"))))])))

;; ============================================================================
;; process operations abstraction
;; ============================================================================

;; spawn process (platform-abstracted)
;; why this function? abstracts process spawning.
;; - host: posix fork/exec
;; - redox: scheme-based process spawning
(define (platform-spawn-process command args)
  (match current-platform
    [':host
     ;; host mode: posix exec
     (spawn-process command args)]
    [':redox
     ;; redox mode: use process: scheme
     (let ([process-url (string-append "process:" command)])
       (scheme-spawn process-url args))]))

;; ============================================================================
;; utility functions
;; ============================================================================

;; get platform name (for logging)
;; why this function? useful for logging and debugging.
(define (get-platform-name)
  (match current-platform
    [':host "host (posix)"]
    [':redox "redox"]))

;; check if running on redox
;; why this function? conditional logic based on platform.
(define (is-redox?)
  (equal? current-platform ':redox))

;; check if running on host
;; why this function? conditional logic based on platform.
(define (is-host?)
  (equal? current-platform ':host))

;; ============================================================================
;; platform-specific implementations (placeholders)
;; ============================================================================

;; note: these are placeholder functions that would be implemented
;; when integrating with actual platform apis.

;; host mode implementations
(define (open-file path mode) #f)  ; placeholder
(define (socket-connect address) #f)  ; placeholder
(define (spawn-process command args) #f)  ; placeholder
(define (serialize-db-to-file db path) #f)  ; placeholder
(define (deserialize-db-from-file path) #f)  ; placeholder
(define (connect-kafka-host address) #f)  ; placeholder
(define (connect-file-log path) #f)  ; placeholder

;; redox mode implementations
(define (open-file-url file-url mode) #f)  ; placeholder
(define (scheme-connect scheme-url) #f)  ; placeholder
(define (scheme-spawn process-url args) #f)  ; placeholder
(define (serialize-db-to-url db url) #f)  ; placeholder
(define (deserialize-db-from-url url) #f)  ; placeholder
(define (connect-kafka-redox tcp-url) #f)  ; placeholder
(define (connect-file-log-redox file-url) #f)  ; placeholder
(define (connect-icp-redox icp-url) #f)  ; placeholder

;; ============================================================================
;; exports
;; ============================================================================

;; platform detection
;; current-platform
;; detect-platform
;; verify-platform
;; get-platform-name
;; is-redox?
;; is-host?

;; file operations
;; file-path (macro)
;; platform-open-file
;; platform-read-file
;; platform-write-file

;; network operations
;; network-url (macro)
;; platform-connect

;; database operations
;; db-path (macro)
;; platform-save-db
;; platform-load-db

;; event log operations
;; event-log-url (macro)
;; platform-connect-event-log

;; process operations
;; platform-spawn-process

