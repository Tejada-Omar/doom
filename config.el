;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
(setq! doom-font (font-spec :family "JetBrains Mono" :size 18)
       doom-big-font (font-spec :family "JetBrains Mono" :size 24)
       doom-variable-pitch-font (font-spec :family "Noto Sans" :size 19))

;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq! doom-theme 'doom-tokyo-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq! display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq! org-directory "~/Documents/org/")

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

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(after! org
  ;; FIXME: org-agenda-prefix-format not picking up org-time-stamp-custom-formats
  ;; Requires additional configuration
  (setq! org-startup-folded 'content)
  (setq! org-log-done t)
  (setq! org-log-into-drawer t)
  (setq! org-time-stamp-custom-formats '("<%m/%d/%y %a>" . "<%m/%d/%y %a %I:%M %p>"))
  (setq! org-capture-templates
         '(("t" "Personal todo entry" entry (file+headline +org-capture-todo-file "Inbox")
            "* TODO %?\n%i\nCaptured on %T\n\nCaptured from %a" :prepend t)
           ("n" "Personal notes" entry
            (file+headline +org-capture-notes-file "Inbox")
            "* %u %?\n%i\n%a" :prepend t)
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

(setq! doom-leader-key "\\"
       doom-leader-alt-key "M-\\"
       doom-localleader-key "SPC"
       doom-localleader-alt-key "M-SPC")

(add-hook 'sh-mode-hook
          #'(lambda ()
              (setq +format-with 'shfmt)
              ))

(use-package! org-edna
  :config (org-edna-mode))

(after! lsp-mode
  (setq! lsp-go-use-gofumpt t)
  (setq! lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedwrite . t)
                           (unusedparams . t)
                           (useany . t)
                           (unusedvariable . t))))

;; TODO: Look into setting depending on major mode
(setq! find-sibling-rules `(("\\([^/]+\\)\\.go\\'" "\\1_test.go") ("\\([^/]+\\)_test\\.go\\'" "\\1.go")))

(after! dirvish
  (setq dirvish-attributes '(vc-state file-size file-time nerd-icons))
  (setq! dirvish-quick-access-entries
         `(("h" "~/" "Home")
           ("c" "~/Code/" "Code")
           ("d" "~/Downloads/" "Downloads")
           ("p" "~/Pictures/" "Base Pictures")
           ("m" "~/media/" "Media Drive")
           ))
  (dirvish-side-follow-mode)
  )

(map! :leader :desc "Dirvish" "o=" 'dirvish)
(map! :leader :desc "Open dirvish side-bar" "op" 'dirvish-side)
