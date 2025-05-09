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

(use-package early-init
  :no-require
  :unless (featurep 'early-init)
  :config
  (load-file (expand-file-name "early-init.el" user-emacs-directory)))

(use-package straight)

(use-package defaults
  :preface
  (setq-default
   enable-recursive-minibuffers t
   indent-tabs-mode nil
   load-prefer-newer t
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
   indent-tabs-mode nil
   frame-resize-pixelwise window-system
   window-resize-pixelwise window-system)
  (provide 'defaults))

(use-package functions
  :preface
  (provide 'functions))

(use-package local-config
  :preface
  (defgroup local-config ()
    "Customization group for local settings."
    :prefix "local-config-"
    :group 'emacs)
  ;; (defcustom local-config-dark-theme 'modus-vivendi-deuteranopia
  ;;   "Dark theme to use."
  ;;   :tag "Dark theme"
  ;;   :type 'symbol
  ;;   :group 'local-config)
  ;; (defcustom local-config-light-theme 'modus-operandi-deuteranopia
  ;;   "Light theme to use."
  ;;   :tag "Light theme"
  ;;   :type 'symbol
  ;;   :group 'local-config)
  (provide 'local-config))


;;; Core packages

(use-package cus-edit
  :custom
  (custom-file (expand-file-name "custom.el" user-emacs-directory))
  :init
  (load custom-file :noerror))

(use-package gcmh
  :straight (:host gitlab :repo "koral/gcmh")
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
  :init
  (fset 'yes-or-no-p 'y-or-n-p))

(use-package modus-themes
  :straight (:host github :repo "protesilaos/modus-themes"))

;; (use-package ef-themes
;;   :straight (:host github :repo "protesilaos/ef-themes"))

(use-package auto-dark
  :straight (:host github :repo "LionyxML/auto-dark-emacs")
  :hook (server-after-make-frame . auto-dark-mode)
  :custom
  (auto-dark-light-theme 'modus-operandi)
  (auto-dark-dark-theme 'modus-vivendi))

(use-package font
  :hook (after-init . setup-fonts)
  :preface
  (defun setup-fonts ()
    (add-to-list 'default-frame-alist '(font . "Iosevka-14")))
  (provide 'font))

(use-package ligature
  :straight (:host github :repo "mickeynp/ligature.el")
  :config
  ;; Enable all Iosevka ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
                                       "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
                                       "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
                                       ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))
  (global-ligature-mode t))

(use-package mood-line
  :straight (:host github :repo "jessiehildebrandt/mood-line")
  :config
  (mood-line-mode))

(use-package savehist
  :custom
  (history-length 50)
  :config
  (savehist-mode))

(use-package menu-bar
  :unless (display-graphic-p)
  :config
  (menu-bar-mode -1))

(use-package scroll-bar
  :unless (display-graphic-p)
  :config
  (scroll-bar-mode -1))

(use-package tool-bar
  :unless (display-graphic-p)
  :config
  (tool-bar-mode -1))

(use-package delsel
  :config
  (delete-selection-mode))

(use-package saveplace
  :config
  (save-place-mode))

(use-package hl-line
  :config
  (global-hl-line-mode))

(use-package paren
  :hook (prog-mode . show-paren-mode))

(use-package which-key
  :straight (:host github :repo "justbur/emacs-which-key")
  :config
  (which-key-mode))

(use-package ace-window
  :straight (:host github :repo "abo-abo/ace-window")
  :config
  (ace-window-display-mode))

(use-package eldoc
  :custom
  (eldoc-echo-area-use-multiline-p nil))

(use-package vundo
  :straight (:host github :repo "casouri/vundo"))

(use-package recentf
  :straight (:type built-in)
  :hook (after-init . recentf-mode)
  :defines (recentf-exclude)
  :custom
  (recentf-max-menu-items 127)
  (recentf-max-saved-items 127)
  :custom
  (recentf-mode t))

(use-package char-fold
  :straight (:type built-in)
  :custom
  (char-fold-symmetric t)
  (search-default-mode #'char-fold-to-regexp))

(use-package reverse-im
  :straight (:host github :repo "a13/reverse-im.el")
  :demand t
  :after char-fold
  :custom
  (reverse-im-char-fold t)
  (reverse-im-read-char-advice-function #'reverse-im-read-char-include)
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))

(use-package jinx
  :straight (:host github :repo "minad/jinx")
  :config
  (global-jinx-mode))

(use-package telega
  :straight (:host github :repo "zevlg/telega.el")
  :custom
  (telega-use-docker t))


;;; Completition & Search

(use-package isearch
  :straight (:type built-in)
  :custom
  (isearch-lazy-count t))

(use-package vertico
  :straight (:host github :repo "minad/vertico")
  :custom
  (vertico-cycle t)
  (vertico-scroll-margin 2)
  :config
  (vertico-mode))

(use-package marginalia
  :straight (:host github :repo "minad/marginalia")
  :config
  (marginalia-mode))

(use-package orderless
  :straight (:host github :repo "oantolin/orderless")
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package corfu
  :straight (:host github :repo "minad/corfu")
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-scroll-margin 2)
  (corfu-quit-no-match 'separator)
  :config
  (global-corfu-mode))

(use-package corfu-terminal
  :straight (:host codeberg :repo "akib/emacs-corfu-terminal")
  :unless (display-graphic-p)
  :after corfu
  :config
  (corfu-terminal-mode 1))

(use-package cape
  :straight (:host github :repo "minad/cape")
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package consult
  :straight (:host github :repo "minad/consult")
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref))

(use-package consult-eglot
  :straight (:host github :repo "mohkale/consult-eglot")
  :after (consult eglot))


;;; Org

(use-package calendar
  :straight (:type built-in)
  :custom
  (calendar-week-start-day 1))

(use-package org
  :straight (:type built-in)
  :hook ((org-mode . org-indent-mode)
         (org-mode . visual-line-mode))
  :custom
  (org-ellipsis " ▾")
  (org-hide-emphasis-markers t)
  (org-capture-bookmark nil))

(use-package org-modern
  :straight (:host github :repo "minad/org-modern"))

(use-package denote
  :straight (:host github :repo "protesilaos/denote")
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
  :straight (:host github :repo "federicotdn/verb"))

;;; Development

(use-package eglot
  :straight (:type built-in)
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
                    "--header-insertion-decorators=0"
                    )))
  (add-to-list 'eglot-server-programs
               '((rust-mode rust-ts-mode) . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs
               '((markdown-mode) . ("marksman"))))

(use-package breadcrumb
  :straight (:host github :repo "joaotavora/breadcrumb")
  :config
  (breadcrumb-mode))

(use-package yasnippet
  :straight (:host github :repo "joaotavora/yasnippet")
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :straight (:host github :repo "AndreaCrotti/yasnippet-snippets"))

(use-package rust-mode
  :straight (:host github :repo "rust-lang/rust-mode"))

(use-package bazel
  :straight (:host github :repo "bazelbuild/emacs-bazel-mode"))

(use-package cmake-mode
  :straight (:host github :repo "Kitware/CMake"
                   :files ("Auxiliary/cmake-mode.el")))

(use-package cmake-project
  :straight (:host github :repo "alamaison/emacs-cmake-project"))

(use-package typescript-mode
  :straight (:host github :repo "emacs-typescript/typescript.el"))

(use-package treesit
  :straight (:type built-in))

;; (use-package treesit-auto
;;   :straight (:host github :repo "renzmann/treesit-auto")
;;   :demand t
;;   :custom
;;   (treesit-auto-install 'prompt)
;;   :config
;;   (treesit-auto-add-to-auto-mode-alist 'all)
;;   (global-treesit-auto-mode))

(use-package go-mode
  :straight (:host github :repo "dominikh/go-mode.el"))

(use-package json
  :straight (:type built-in))

(use-package yaml-mode
  :straight (:host github :repo "yoshiki/yaml-mode"))

(use-package csv-mode
  :straight (:host github :repo "emacs-straight/csv-mode")
  :custom
  (csv-align-max-width 80))

(use-package lua-mode
  :straight (:host github :repo "immerrr/lua-mode"))

(use-package zig-mode
  :straight (:host github :repo "ziglang/zig-mode"))

(use-package markdown-mode
  :straight (:host github :repo "jrblevin/markdown-mode")
  :hook (markdown-mode . visual-line-mode))

(use-package protobuf-mode
  :straight (:host github :repo "protocolbuffers/protobuf"
                   :files ("editors/protobuf-mode.el")))

(use-package dockerfile-mode
  :straight (:host github :repo "spotify/dockerfile-mode"))

(use-package docker
  :straight (:host github :repo "Silex/docker.el"))

(use-package rmsbolt
  :straight (:host gitlab :repo "jgkamat/rmsbolt")
  :defer t)

(use-package hl-todo
  :straight (:host github :repo "tarsius/hl-todo")
  :custom
  (hl-todo-keyword-faces
   '(("TODO"   . "#FF0000")
     ("FIXME"  . "#FF0000")
     ("DEBUG"  . "#A020F0")
     ("GOTCHA" . "#FF4500")
     ("STUB"   . "#8E90FF")))
  :config
  (global-hl-todo-mode))

(use-package leetcode
  :straight (:host github :repo "kaiwk/leetcode.el")
  :defer t
  :custom
  (leetcode-prefer-language "cpp")
  (leetcode-save-solutions t))


;;; Git

(use-package magit
  :straight (:host github :repo "magit/magit")
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package diff-hl
  :straight (:host github :repo "dgutov/diff-hl")
  :requires (magit)
  :config
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode))


;;; Key bindings

;; (use-package devil
;; :straight (:host github :repo "susam/devil"))

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
         ;; yasnippet
         (:map prog-mode-map
               ("C-c y n" . yas-next-field)
               ("C-c y p" . yas-prev-field)
               ("C-c y i" . yas-insert-snippet))
         ;; dired
         (:map dired-mode-map
               ("<backspace>" . dired-up-directory)
               ("~" . dired-home-directory))
         ;; reverse-im
         (:map global-map
               ("M-T" . reverse-im-translate-word)))
  :config
  (provide 'bindings))


(provide 'init)
;;; init.el ends here

