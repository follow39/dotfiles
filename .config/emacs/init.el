;;; init.el --- Main configuration file -*- lexical-binding: t; no-byte-compile: t; outline-regexp: "^;;;;*[[:space:]]\\w" -*-

;; Author: Artem Ivanov
;; Keywords: Emacs configuration
;; Homepage: https://github.com/follow39/dotfiles

;;; Commentary:
;; Emacs 29.1+ configuration.

;;; Code:

(use-package use-package
  :no-require
  :custom
  (use-package-enable-imenu-support t))

(use-package package
  :config
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

(use-package defaults
  :preface
  (setq-default
   enable-recursive-minibuffers t
   indent-tabs-mode nil
   truncate-lines t
   bidi-paragraph-direction 'left-to-right
   frame-title-format "Emacs"
   auto-window-vscroll nil
   mouse-highlight t
   hscroll-step 1
   hscroll-margin 1
   scroll-margin 17
   scroll-preserve-screen-position nil
   ;; scroll-conservatively 101
   tab-width 2
   frame-resize-pixelwise window-system
   window-resize-pixelwise window-system
   read-process-output-max (* 1024 1024 8)
   inhibit-compacting-font-caches t
   message-log-max 16384
   x-gtk-resize-child-frames 'resize-mode
   fringe-indicator-alist (assq-delete-all 'truncation fringe-indicator-alist)
   native-comp-async-report-warnings-errors 'silent)
  (provide 'defaults))

(use-package local-config
  :preface
  (defgroup local-config ()
    "Customization group for local settings."
    :prefix "local-config-"
    :group 'emacs)
  (defcustom local-config-dark-theme 'modus-vivendi-deuteranopia
    "Dark theme to use."
    :tag "Dark theme"
    :type 'symbol
    :group 'local-config)
  (defcustom local-config-light-theme 'modus-operandi-deuteranopia
    "Light theme to use."
    :tag "Light theme"
    :type 'symbol
    :group 'local-config)
  (provide 'local-config))


;;; Core packages

(use-package cus-edit
  :custom
  (custom-file (expand-file-name "custom.el" user-emacs-directory))
  :init
  (load custom-file :noerror))

(use-package gcmh
  :ensure t
  :demand nil
  :config
  (gcmh-mode 1))

(use-package autorevert
  :config
  (global-auto-revert-mode 1))

(use-package startup
  :no-require
  :custom
  (user-mail-address "ingang39@gmail.com")
  (user-full-name "Artem Ivanov"))

(use-package dired
  :hook (dired-mode . dired-hide-details-mode)
  :config
  (defun dired-home-directory ()
    (interactive)
    (dired (expand-file-name "~/"))))

(use-package files
  :preface
  (defvar backup-dir
    (expand-file-name ".cache/backups" user-emacs-directory)
    "Directory to store backups.")
  (defvar auto-save-dir
    (expand-file-name ".cache/auto-save/" user-emacs-directory)
    "Directory to store auto-save files.")
  :custom
  (backup-by-copying t)
  (create-lockfiles nil)
  (backup-directory-alist
   `(("." . ,backup-dir)))
  (auto-save-file-name-transforms
   `((".*" ,auto-save-dir t)))
  (auto-save-no-message t)
  (auto-save-interval 100)
  (require-final-newline t)
  :config
  (unless (file-exists-p auto-save-dir)
    (make-directory auto-save-dir t)))

(use-package subr
  :no-require
  :custom
  (use-short-answers t))

(use-package modus-themes
  :ensure t
  :config
  (defun local-config-update-theme ()
    "Load the light theme from 07:00 to 20:00 and the dark theme at other times."
    (let* ((hour (decoded-time-hour (decode-time)))
           (theme (if (<= 7 hour 19)
                      local-config-light-theme
                    local-config-dark-theme)))
      (unless (equal custom-enabled-themes (list theme))
        (mapc #'disable-theme custom-enabled-themes)
        (load-theme theme t))))
  (local-config-update-theme)
  (run-at-time 600 600 #'local-config-update-theme))

(use-package font
  :hook (after-init . setup-fonts)
  :preface
  (defun setup-fonts ()
    (add-to-list 'default-frame-alist '(font . "Iosevka-14")))
  (provide 'font))

(use-package ligature
  :ensure t
  :config
  ;; Enable all Iosevka ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  (global-ligature-mode t))

(use-package mood-line
  :ensure t
  :config
  (mood-line-mode))

(use-package savehist
  :custom
  (savehist-autosave-interval 30)
  :config
  (savehist-mode))

(use-package delsel
  :config
  (delete-selection-mode))

(use-package saveplace
  :config
  (save-place-mode)
  ;; Save also when Emacs stops without running `kill-emacs-hook'.
  (run-with-idle-timer 30 t (lambda ()
                              (let ((inhibit-message t))
                                (save-place-kill-emacs-hook)))))

(use-package hl-line
  :config
  (global-hl-line-mode))

(use-package paren
  :hook (prog-mode . show-paren-mode))

(use-package which-key
  :config
  (which-key-mode))

(use-package ace-window
  :ensure t
  :config
  (ace-window-display-mode))

(use-package eldoc
  :custom
  (eldoc-echo-area-use-multiline-p nil))

(use-package vundo
  :ensure t)

(use-package recentf
  :hook (after-init . recentf-mode)
  :custom
  (recentf-max-menu-items 127)
  (recentf-max-saved-items 127)
  :config
  ;; Save also when Emacs stops without running `kill-emacs-hook'.
  (run-with-idle-timer 30 t (lambda ()
                              (let ((inhibit-message t))
                                (recentf-save-list)))))

(use-package jinx
  :ensure t
  :config
  (global-jinx-mode))


;;; Completion & Search

(use-package isearch
  :custom
  (isearch-lazy-count t))

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  (vertico-scroll-margin 2)
  :config
  (vertico-mode))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-scroll-margin 2)
  (corfu-quit-no-match 'separator)
  :config
  (global-corfu-mode))

(use-package corfu-terminal
  :ensure t
  :unless (display-graphic-p)
  :after corfu
  :config
  (corfu-terminal-mode 1))

(use-package cape
  :ensure t
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package consult
  :ensure t
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref))

(use-package consult-eglot
  :ensure t
  :after (consult eglot))


;;; Org

(use-package calendar
  :custom
  (calendar-week-start-day 1))

(use-package org
  :hook ((org-mode . org-indent-mode)
         (org-mode . visual-line-mode))
  :custom
  (org-ellipsis " ▾")
  (org-hide-emphasis-markers t)
  (org-capture-bookmark nil))

(use-package org-modern
  :ensure t)

(use-package denote
  :ensure t
  :custom
  (denote-directory (expand-file-name "~/Documents/notes/"))
  (denote-known-keywords '("emacs" "inbox"))
  (denote-infer-keywords t)
  (denote-sort-keywords t)
  (denote-file-type nil) ; Org is the default
  (denote-prompts '(title keywords))
  (denote-excluded-directories-regexp nil)
  (denote-excluded-keywords-regexp nil)
  ;; Pick dates, where relevant, with Org's advanced interface:
  (denote-date-prompt-use-org-read-date t)
  (denote-org-capture-specifiers "%i\n%?"))

(use-package verb
  :ensure t)

;;; Development

(use-package eglot
  :custom
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  (eglot-connect-timeout 10)
  :config
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode)
                 . ("clangd"
                    "-j=4"
                    "--log=error"
                    "--background-index"
                    "--clang-tidy"
                    "--cross-file-rename"
                    "--completion-style=detailed"
                    "--header-insertion=iwyu"
                    "--header-insertion-decorators=0"))))

(use-package dape
  :ensure t)

(use-package breadcrumb
  :ensure t
  :config
  (breadcrumb-mode))

(use-package bazel
  :ensure t)

(use-package cmake-project
  :ensure t)

(use-package treesit
  :custom
  (treesit-language-source-alist
   '((c "https://github.com/tree-sitter/tree-sitter-c")
     (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
     (rust "https://github.com/tree-sitter/tree-sitter-rust")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src")
     (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml"))))

;; The tree-sitter modes add their file mappings only when they load.

(use-package cmake-ts-mode
  :demand t)

(use-package dockerfile-ts-mode
  :demand t)

(use-package rust-ts-mode
  :demand t)

(use-package typescript-ts-mode
  :demand t)

(use-package yaml-ts-mode
  :demand t)

;; Load after `typescript-ts-mode', which loads `cc-mode'.
;; `cc-mode' turns off the `c-mode' to `c-ts-mode' remap.
(use-package c-ts-mode
  :demand t)

(use-package csv-mode
  :ensure t
  :custom
  (csv-align-max-width 80))

(use-package zig-mode
  :ensure t)

(use-package markdown-mode
  :ensure t
  :hook (markdown-mode . visual-line-mode))

(use-package protobuf-mode
  :ensure t)

(use-package docker
  :ensure t)

(use-package hl-todo
  :ensure t
  :custom
  (hl-todo-keyword-faces
   '(("TODO"   . "#FF0000")
     ("FIXME"  . "#FF0000")
     ("DEBUG"  . "#A020F0")
     ("GOTCHA" . "#FF4500")
     ("STUB"   . "#8E90FF")))
  :config
  (global-hl-todo-mode))


;;; Git

(use-package magit
  :ensure t
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package diff-hl
  :ensure t
  :requires (magit)
  :config
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode))


;;; Key bindings

(use-package bindings
  :bind (;; consult
         ((:map global-map
                ;; C-c bindings in `mode-specific-map'
                ("C-c M-x" . consult-mode-command)
                ("C-c h" . consult-history)
                ("C-c k" . consult-kmacro)
                ("C-c m" . consult-man)
                ("C-c i" . consult-info)
                ([remap Info-search] . consult-info)
                ;; C-x bindings in `ctl-x-map'
                ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
                ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
                ("C-x C-b" . consult-buffer)
                ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
                ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
                ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
                ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
                ;; Custom M-# bindings for fast register access
                ("M-#" . consult-register-load)
                ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
                ("C-M-#" . consult-register)
                ;; Other custom bindings
                ("M-y" . consult-yank-pop)                ;; orig. yank-pop
                ;; M-g bindings in `goto-map'
                ("M-g e" . consult-compile-error)
                ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
                ("M-g g" . consult-goto-line)             ;; orig. goto-line
                ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
                ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
                ("M-g m" . consult-mark)
                ("M-g k" . consult-global-mark)
                ("M-g i" . consult-imenu)
                ("M-g I" . consult-imenu-multi)
                ("M-g s" . consult-eglot-symbols)
                ;; M-s bindings in `search-map'
                ("M-s d" . consult-find)
                ("M-s D" . consult-locate)
                ("M-s g" . consult-grep)
                ("M-s G" . consult-git-grep)
                ("M-s r" . consult-ripgrep)
                ("M-s l" . consult-line)
                ("M-s L" . consult-line-multi)
                ("M-s k" . consult-keep-lines)
                ("M-s u" . consult-focus-lines)
                ;; Isearch integration
                ("M-s e" . consult-isearch-history))
          (:map isearch-mode-map
                ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
                ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
                ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
                ("M-s L" . consult-line-multi))            ;; needed by consult-line to detect isearch
          ;; Minibuffer history
          (:map minibuffer-local-map
                ("M-s" . consult-history)                 ;; orig. next-matching-history-element
                ("M-r" . consult-history)))
         ;; ace-window
         (:map global-map
               ("C-c w" . ace-window))
         ;; vundo
         (:map global-map
               ("C-c u" . vundo))
         ;; org
         (:map global-map
               ("C-c o a" . org-agenda))
         ;; denote
         (:map global-map
               ("C-c n n" . denote))
         ;; eglot
         (:map prog-mode-map
               ("C-c e e" . eglot)
               ("C-c e r" . eglot-rename)
               ("C-c e f" . eglot-format-buffer)
               ("C-c e a" . eglot-code-actions)
               ("C-c e q" . eglot-shutdown))
         ;; dired
         (:map dired-mode-map
               ("<backspace>" . dired-up-directory)
               ("~" . dired-home-directory)))
  :config
  (provide 'bindings))


(provide 'init)
;;; init.el ends here

