;;; early-init.el --- Early initialization -*- lexical-binding: t; no-byte-compile: t -*-

;; Author: Artem Ivanov
;; Keywords: Emacs configuration
;; Homepage: https://github.com/follow39/dotfiles

;;; Commentary:
;; Emacs 29+ early initialization configuration.

;;; Code:

;; `gcmh' manages garbage collection after startup.
(setq gc-cons-threshold most-positive-fixnum)

(setq-default
 default-frame-alist '((fullscreen . maximized)
                       (bottom-divider-width . 0)
                       (right-divider-width . 1))
 frame-inhibit-implied-resize t)

(menu-bar-mode -1)

(when (fboundp #'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp #'scroll-bar-mode)
  (scroll-bar-mode -1))

(unless (or (daemonp) noninteractive)
  (let ((restore-file-name-handler-alist file-name-handler-alist))
    (setq-default file-name-handler-alist nil)
    (defun restore-file-handler-alist ()
      (setq file-name-handler-alist
            (delete-dups (append file-name-handler-alist
                                 restore-file-name-handler-alist)))))
  (add-hook 'emacs-startup-hook #'restore-file-handler-alist 101))

(provide 'early-init)
;;; early-init.el ends here
