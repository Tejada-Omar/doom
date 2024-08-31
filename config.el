;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Packages must be reconfigured in a `after!' block, except when:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded
;;   - Setting doom variables (which start with 'doom-' or '+')
;;
;; Additional functions/macros to configure Doom
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys

;;; Emacs Specific

(after! org
  (load! "private" doom-user-dir t))

;;; Theming

;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
(setq! doom-font (font-spec :family "JetBrains Mono" :size 18)
       doom-big-font (font-spec :family "JetBrains Mono" :size 24)
       doom-variable-pitch-font (font-spec :family "Noto Sans" :size 19))

;; Can be loaded with `doom-theme' variable or `load-theme' function
(setq! doom-theme 'doom-tokyo-night)
(setq! +doom-dashboard-functions '(doom-dashboard-widget-banner))

(setq! display-line-numbers-type 'relative)

;;; Editor
;;;; Basic Settings

;; Changing indent widths
(setq! tab-width 2)

(setq! sh-basic-offset 2)
(setq! c-basic-offset 2)

;; Restore native vim "s" functionality
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

;; TODO: Look into *removing* extraneous newlines
(setq! require-final-newline nil)
(setq! mode-require-final-newline nil)

;; Make `cw' behave like `cw' not `ce'
(setq! evil-want-change-word-to-end nil)

(setq! doom-leader-key "\\"
       doom-leader-alt-key "M-\\"
       doom-localleader-key "SPC"
       doom-localleader-alt-key "M-SPC")

(setq! select-enable-primary t)

;;;; Formatters

(add-hook 'sh-mode-hook
          #'(lambda ()
              (setq +format-with 'shfmt)))

;;;; Navigation

;; TODO: Look into setting depending on major mode
(setq! find-sibling-rules
       `(("\\([^/]+\\)\\.go\\'" "\\1_test.go") ("\\([^/]+\\)_test\\.go\\'" "\\1.go")
         ("\\([^/]+\\)\\.org\\'" "\\1.org_archive") ("\\([^/]+\\)\\.org_archive\\'" "\\1.org")))

(after! dirvish
  (setq dirvish-attributes '(vc-state file-size file-time nerd-icons))
  (setq! dirvish-quick-access-entries
         `(("h" "~/" "Home")
           ("c" "~/Code/" "Code")
           ("a" "~/Documents/" "Documents")
           ("d" "~/Downloads/" "Downloads")
           ("p" "~/Pictures/" "Base Pictures")
           ("m" "~/media/" "Media Drive")))
  (dirvish-side-follow-mode))

(map! :leader :desc "Dirvish" "o=" #'dirvish)
(map! :leader :desc "Open dirvish side-bar" "op" #'dirvish-side)

;;;; LSP

(after! lsp-mode
  (setq! lsp-go-use-gofumpt t)
  (setq! lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedwrite . t)
                           (unusedparams . t)
                           (useany . t)
                           (unusedvariable . t))))

(map! :map dap-mode-map
      :leader
      :prefix ("d" . "dap")
      ;; basics
      :desc "dap next"          "n" #'dap-next
      :desc "dap step in"       "i" #'dap-step-in
      :desc "dap step out"      "o" #'dap-step-out
      :desc "dap continue"      "c" #'dap-continue
      :desc "dap hydra"         "h" #'dap-hydra
      :desc "dap debug restart" "r" #'dap-debug-restart
      :desc "dap debug"         "s" #'dap-debug

      ;; debug
      :prefix ("dd" . "Debug")
      :desc "dap debug recent"  "r" #'dap-debug-recent
      :desc "dap debug last"    "l" #'dap-debug-last

      ;; eval
      :prefix ("de" . "Eval")
      :desc "eval"                "e" #'dap-eval
      :desc "eval region"         "r" #'dap-eval-region
      :desc "eval thing at point" "s" #'dap-eval-thing-at-point
      :desc "add expression"      "a" #'dap-ui-expressions-add
      :desc "remove expression"   "d" #'dap-ui-expressions-remove

      :prefix ("db" . "Breakpoint")
      :desc "dap breakpoint toggle"      "b" #'dap-breakpoint-toggle
      :desc "dap breakpoint condition"   "c" #'dap-breakpoint-condition
      :desc "dap breakpoint hit count"   "h" #'dap-breakpoint-hit-condition
      :desc "dap breakpoint log message" "l" #'dap-breakpoint-log-message)

;;; Org

;; Must be set before org loads
(setq! org-directory "~/Documents/org/")

(after! org
  ;; FIXME: org-agenda-prefix-format not picking up org-time-stamp-custom-formats
  ;; Requires additional configuration
  (setq! org-startup-folded 'content)
  (setq! org-log-done t)
  (setq! org-log-into-drawer t)
  (setq! org-time-stamp-custom-formats '("<%m/%d/%y %a>" . "<%m/%d/%y %a %I:%M %p>"))
  (setq! org-modules '(ol-bibtex org-habit))
  (setq! +org-capture-todo-file "inbox.org")
  (setq! org-id-link-consider-parent-id)
  (setq! org-agenda-skip-scheduled-repeats-after-deadline t)
  (setq! org-agenda-skip-deadline-prewarning-if-scheduled t)
  (setq! org-capture-templates
         '(("t" "Personal todo entry" entry (file +org-capture-todo-file)
            "* TODO %?\n%i %^{CREATED|%U}p\n%a" :prepend t)
           ("n" "Personal notes" entry
            (file+headline +org-capture-notes-file "Inbox")
            "* %?\n%i\n%a %^{CREATED|%U}p" :prepend t)
           ("j" "Journal" entry
            (file+olp+datetree +org-capture-journal-file)
            "* %U %?\n%i\n%a" :prepend t)
           ("p" "Templates for projects")
           ("pt" "Project-local todo" entry
            (file+headline +org-capture-project-todo-file "Inbox")
            "* TODO %?\n%i\n%a" :prepend t)
           ("pn" "Project-local notes" entry
            (file+headline +org-capture-project-notes-file "Inbox")
            "* %U %?\n%i\n%a" :prepend t)
           ("pc" "Project-local changelog" entry
            (file+headline +org-capture-project-changelog-file "Unreleased")
            "* %U %?\n%i\n%a" :prepend t)
           ("o" "Centralized templates for projects")
           ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
           ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
           ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t))))

(use-package! org-alert
  :custom
  (alert-default-style 'libnotify) ;; TODO: Look into expanding customization over dbus notifications
  (org-alert-notification-title "Org Alert Reminder!")
  (org-alert-interval 300)
  :config (org-alert-enable))

;;;; Calendar

(after! org-gcal
  (setq! org-gcal-cancelled-todo-keyword "KILL"
         org-gcal-recurring-events-mode 'nested))

(map! :leader :desc "Open cfw calendar" "oc" #'cfw:open-org-calendar)

;;; RSS

(map! :leader :desc "Elfeed" "os" #'elfeed)
(map! :mode elfeed-search-mode :localleader :desc "Refresh elfeed" "r" #'elfeed-update)

;;; Magit

(setq! magit-branch-read-upstream-first 'fallback)