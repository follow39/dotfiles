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
  :defer t
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
  :defer t
  :preface
  (provide 'functions))

(use-package local-config
  :defer t
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
  :straight (:host github :repo "protesilaos/modus-themes")
  :defer)

(use-package ef-themes
  :straight (:host github :repo "protesilaos/ef-themes")
  :defer)

(use-package circadian
  :straight (:host github :repo "guidoschmidt/circadian.el")
  :requires (local-config)
  :config
  ;; (setq circadian-themes '(("7:30" . ef-light)
                           ;; ("19:30" . ef-night)))
  (setq calendar-latitude 44.786568)
  (setq calendar-longitude 20.448921)
  (setq circadian-themes '((:sunrise . ef-light)
                           (:sunset  . ef-night)))
  (circadian-setup))

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
  :config
  (setq history-length 50)
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

;; (use-package yascroll
;;   :straight (:host github :repo "emacsorphanage/yascroll")
;;   :custom
;;   (setq yascroll:delay-to-hide nil)
;;   :config
;;   (global-yascroll-bar-mode 1))

(use-package vundo
  :straight (:host github :repo "casouri/vundo"))

(use-package recentf
  :hook (after-init . recentf-mode)
  :defines (recentf-exclude)
  :custom
  (recentf-max-menu-items 25)
  (recentf-max-saved-items 100)
  :custom)


;;; Completition

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

;; (use-package corfu-popupinfo
;;   :bind ( :map corfu-popupinfo-map
;;           ("M-p" . corfu-popupinfo-scroll-down)
;;           ("M-n" . corfu-popupinfo-scroll-up))
;;   :hook (corfu-mode . corfu-popupinfo-mode)
;;   :custom-face
;;   (corfu-popupinfo ((t :height 1.0))))

(use-package cape
  :straight (:host github :repo "minad/cape")
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package consult
  :straight (:host github :repo "minad/consult"))


;;; Development

(use-package eglot
  :defer t
  :custom
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  (eglot-connect-timeout 10)
  :config
  (setq )
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode)
                 . ("clangd"
                    "-j=4"
                    "--log=error"
                    "--background-index"
                    "--clang-tidy"
                    "--cross-file-rename"
                    "--completion-style=detailed"
                    "--header-insertion=never"
                    "--header-insertion-decorators=0"
                    )))
  (add-to-list 'eglot-server-programs
               '((rust-mode rust-ts-mode) . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs
               '((markdown-mode) . ("marksman"))))

(use-package yasnippet
  :straight (:host github :repo "joaotavora/yasnippet")
  :config
  (yas-global-mode 1))

(use-package rust-mode
  :straight (:host github :repo "rust-lang/rust-mode")
  :after eglot)


(use-package bazel-mode
  :straight (:host github :repo "bazelbuild/emacs-bazel-mode")
  :defer t)

(use-package treesit)

(use-package treesit-auto
  :straight (:host github :repo "renzmann/treesit-auto")
  :config
  (global-treesit-auto-mode))

(use-package json-mode
  :defer t)

(use-package csv-mode
  :straight t
  :defer t
  :custom
  (csv-align-max-width 80))

(use-package lua-mode
  :straight (:host github :repo "immerrr/lua-mode")
  :defer t)

(use-package zig-mode
  :straight (:host github :repo "ziglang/zig-mode")
  :defer t)

(use-package markdown-mode
  :straight t)


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


;;; Org mode

(use-package org-mode
  :defer t
  :custom
  (org-ellipsis " ▾")
  (org-hide-emphasis-markers t)
  (org-agenda-start-with-log-mode t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-agenda-files '("~/Documents/projects/org-test/Tasks.org"))
  :config)

(use-package org-roam
  :straight (:host github :repo "org-roam/org-roam"
                   :files (:defaults "extensions/*"))
  :defer t
  :custom
  (org-roam-directory (file-truename "~/Documents/projects/org-test/"))
  :config
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))

(use-package org-appear
  :straight (:host github :repo "awth13/org-appear"))


;;; Bindings

(use-package bindings
  :bind (("C-x b" . consult-buffer)
         ("C-x C-b" . consult-buffer)
         ("M-y" . consult-yank-from-kill-ring)
         ("C-s" . consult-line)
         ("C-c c b" . consult-bookmark)
         ("C-c c i" . consult-imenu)
         ("C-c c u" . consult-imenu-multi)
         ("C-c c d" . consult-flymake)
         ("C-c c f" . consult-find)
         ("C-c c r" . consult-git-grep)
         ("C-c c r" . consult-ripgrep)
         ("C-c c o" . consult-buffer-other-window)
         ("C-c c p" . consult-project-buffer)
         ("C-c w" . ace-window)
         ("C-c u" . vundo)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today)
         (:map prog-mode-map
               ("C-c e e" . eglot)
               ("C-c e r" . eglot-rename)
               ("C-c e f" . eglot-format-buffer)
               ("C-c y n" . yas/next-field)
               ("C-c y p" . yas/prev-field))
         ( :map dired-mode-map
           ("<backspace>" . dired-up-directory)
           ("~" . dired-home-directory)))
  :config
  (provide 'bindings))


(provide 'init)
;;; init.el ends here

