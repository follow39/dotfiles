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
  :straight (:host gitlab :repo "koral/gcmh")
  :demand nil
  :config
  (gcmh-mode 1))

(use-package autorevert
  :config
  (global-auto-revert-mode))

(use-package startup
  :no-require
  :custom
  (user-mail-address "ingang39@gmail.com")
  (user-full-name "Artem Ivanov"))

;; todo
(use-package dired
  :bind ( :map dired-mode-map
          ("<backspace>" . dired-up-directory)
          ("~" . dired-home-directory))
  :hook (dired-mode . dired-hide-details-mode)
  ;; :custom
  ;; (dired-listing-switches "-lAXhv --group-directories-first")
  :config
  (defun dired-home-directory ()
    (interactive)
    (dired (expand-file-name "~/"))))

;; todo
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
  :requires (functions local-config)
  :config
  (setq current-hour
        (string-to-number
         (format-time-string "%H" (current-time))))
  (if (member current-hour (number-sequence 6 18))
      (load-theme local-config-light-theme t)
    (load-theme local-config-dark-theme t))
  (run-at-time "09:00" (* 60 60 24) (lambda () (load-theme local-config-light-theme t)))
  (run-at-time "18:00" (* 60 60 24) (lambda () (load-theme local-config-dark-theme t))))

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

(use-package tooltip-bar
  :unless (display-graphic-p)
  :config
  (tooltip-bar-mode -1))

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
  :bind (("C-c C-w" . ace-window))
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
  :straight (:host github :repo "casouri/vundo")
  :bind (("C-c u" . vundo)))

(use-package recentf
  :hook (after-init . recentf-mode)
  :defines (recentf-exclude)
  :custom
  (recentf-max-menu-items 100)
  (recentf-max-saved-items 100))


;;; Completition

(use-package vertico
  :straight (:host github :repo "minad/vertico")
  :config
  (setq vertico-cycle t
        vertico-scroll-margin 2)
  (vertico-mode))

(use-package marginalia
  :straight (:host github :repo "minad/marginalia")
  :config
  (marginalia-mode))

(use-package orderless
  :straight (:host github :repo "oantolin/orderless")
  :config
  (setq completion-styles '(orderless)))

(use-package corfu
  :straight (:host github :repo "minad/corfu")
  :config
  (setq corfu-auto t
        corfu-cycle t
        corfu-scroll-margin 2
        corfu-quit-no-match 'separator)
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
  :straight (:host github :repo "minad/consult")
  :bind (("C-s" . consult-line)
         ("C-M-l" . consult-imenu)))


;;; Development

(use-package eglot
  :bind (("C-c C-f" . eglot-format-buffer))
  :config
  (setq eglot-autoshutdown t
        eglot-extend-to-xref t
        eglot-connect-timeout 10)
  ;; (eglot-inlay-hints-mode)
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode)
                 . ("clangd"
                    "-j=4"
                    "--log=error"
                    "--malloc-trim"
                    "--background-index"
                    "--clang-tidy"
                    "--cross-file-rename"
                    "--completion-style=detailed"
                    "--pch-storage=memory"
                    "--header-insertion=never"
                    "--header-insertion-decorators=0"))
               '((rust-mode) . ("rust-analyzer"))))

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

;;; Git

(use-package magit
  :straight (:host github :repo "magit/magit")
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package diff-hl
  :straight (:host github :repo "dgutov/diff-hl")
  :config
  (global-diff-hl-mode))


;;; Bindings

(use-package bindings
  :bind (("C-x C-b" . switch-to-buffer)))


(provide 'init)
;;; init.el ends here
