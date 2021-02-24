;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ramsay Carslaw"
      user-mail-address "ramsaycarslaw@icloud.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq moe-theme-highlight-buffer-id t)
(setq doom-theme 'doom-wilmersdorf)

(setq doom-font (font-spec :family "Fira Code") 
      doom-variable-pitch-font (font-spec :family "Cantarell"))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(after! evil-org
  (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/dox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; ------------------------------------------------------------
;;                      Window Control
;; ------------------------------------------------------------

;; make emacs use exactly half of the screen on the left
(defun rcc-frame-resize-l ()
  "set frame full height and 86 columns wide and position at screen left"
  (interactive)
  (set-frame-width (selected-frame) 91)
  (set-frame-height (selected-frame) 45)
  (set-frame-position (selected-frame) 0 0))

;; make emacs use exactly half of the screen on the right
(defun rcc-frame-resize-r ()
  "set frame full height and 86 columns wide and position at screen right"
  (interactive)
  (set-frame-width (selected-frame) 91)
  (set-frame-height (selected-frame) 45)
  (set-frame-position (selected-frame) (- (display-pixel-width) (frame-pixel-width)) 0))

(global-set-key (kbd "<s-M-left>") 'rcc-frame-resize-l)
(global-set-key (kbd "<s-M-right>") 'rcc-frame-resize-r)

(global-set-key (kbd "C-s") 'helm-swoop)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-mini)

;; ------------------------------------------------------------
;;                      C/C++ + LSP
;; ------------------------------------------------------------

(setq lsp-ui-doc-enable t
      lsp-ui-doc-use-childframe t
      lsp-ui-doc-position 'top
      lsp-ui-doc-include-signature t
      lsp-ui-sideline-enable nil
      lsp-ui-flycheck-enable t
      lsp-ui-flycheck-list-position 'right
      lsp-ui-flycheck-live-reporting t
      lsp-ui-peek-enable t
      lsp-ui-peek-list-width 60
      lsp-ui-peek-peek-height 25)

(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(setq company-idle-delay 0
      company-show-numbers nil
      company-dabbrev-ignore-case 1
      company-selection-wrap-around t
      company-minimum-prefix-length 1
      company-tooltip-align-annotations t)

(setq company-box-doc-enable nil)
(setq company-box-icons-all-the-icons t)
(setq company-box-scrollbar t)
(setq company-box-backends-colors nil)
(setq show-trailing-whitespace nil)
(add-hook 'company-mode-hook  'company-box-mode)

(setq ccls-executable "ccls")
(setq lsp-prefer-flymake 1)
(add-hook 'c-mode-hook (lambda () (require 'ccls) (lsp)))
(add-hook 'c++-mode-hook (lambda () (require 'ccls) (lsp)))
(setq c-default-style "linux")
(setq-default c-basic-offset 2)

;; -------------------------------------------------------------------------
;;                           Org
;; -------------------------------------------------------------------------

(defun org-conf ()
  (variable-pitch-mode 1)

  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1))
     (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch))
)

(setq org-ellipsis " ▾")

(add-hook 'org-mode-hook 'org-conf)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))
