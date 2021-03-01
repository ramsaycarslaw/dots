
 (setq default-directory "/Users/ramsaycarslaw/")

;; ------------------------------------------------------------
;;                             Packages
;; ------------------------------------------------------------

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Not on SSL."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;;; bootstarp use package

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; ------------------------------------------------------------
;;                         Emacs Settings       
;; ------------------------------------------------------------

(use-package emacs
  :init
  (set-face-attribute 'default nil :font "SF Mono")
  (set-frame-font "SF Mono" nil t)
  (global-visual-line-mode t)
  :config

  (when window-system (set-fringe-mode 0))
  (global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))
  
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

  ;; disable yes-no
  (fset 'yes-or-no-p 'y-or-n-p)

  ;; store all backups in .emacs.d/backup
  (setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
	backup-by-copying t
	version-control t
	delete-old-versions t
	kept-new-versions 20
	kept-old-versions 5
	shell-file-name "/bin/zsh")

  (delete-selection-mode t)
  (global-visual-line-mode t)
  (show-paren-mode t)
  )

(use-package tool-bar
  :config
  (tool-bar-mode 0))

(use-package scroll-bar
  :config
  (scroll-bar-mode 0))

;; line numbers
(use-package display-line-numbers
  :ensure t
  :config
  (setq display-line-numbers-type 'relative)
  (global-display-line-numbers-mode t))

(use-package exec-path-from-shell
  :ensure t
  :config (when (memq window-system '(mac ns x))
	    (exec-path-from-shell-initialize))
  (setenv "GOPATH" "/Users/ramsaycarslaw/go"))

;; ------------------------------------------------------------
;;                       Evil Mode 
;; ------------------------------------------------------------

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>h") 'windmove-left)
  (evil-define-key 'normal 'global (kbd "<leader>j") 'windmove-down)
  (evil-define-key 'normal 'global (kbd "<leader>k") 'windmove-up)
  (evil-define-key 'normal 'global (kbd "<leader>l") 'windmove-right))

;; ------------------------------------------------------------
;;                         Helm
;; ------------------------------------------------------------

;;Helm setup
(use-package helm
  :ensure t
  :demand t
  :init
  (progn
    (require 'helm-config)
    ;; limit max number of matches displayed for speed
    (setq helm-candidate-number-limit 100)
    ;; ignore boring files like .o and .a
    (setq helm-ff-skip-boring-files t)
    ;; replace locate with spotlight on Mac
    (setq helm-locate-command "mdfind -name %s %s"))
  
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-mini)
	 ("C-x C-b" . helm-mini)
	 ("M-y" . helm-show-kill-ring))
  :config
  (helm-mode 1)
  (evil-define-key 'normal 'global (kbd "<leader>f") 'helm-find-files)
  (evil-define-key 'normal 'global (kbd "<leader>b") 'helm-mini)
  (helm-autoresize-mode 1) 
  (setq helm-autoresize-max-height 30
	helm-autoresize-min-height 30)
  )

;; Helm Swoop is still the best search
(use-package helm-swoop
  :ensure t
  :demand t
  :bind (("\C-s" . helm-swoop))
  :config
  (evil-define-key 'normal 'global (kbd "<leader>s") 'helm-swoop)
  )

;; ------------------------------------------------------------
;;                           Magit
;; ------------------------------------------------------------

(use-package magit
  :ensure t
  :bind
  ("C-x g" . magit-status)
  ("C-x M-g" . magit-dispatch)
  :config
  (evil-define-key 'normal 'global (kbd "<leader>g") 'magit-status)
  )

;; ------------------------------------------------------------
;;                          Themes
;; ------------------------------------------------------------

(use-package gotham-theme
  :ensure t)

(load-theme 'gotham-dark t)

(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)

  (evil-goggles-use-diff-faces))

;; ------------------------------------------------------------
;;                         Markdown
;; ------------------------------------------------------------

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; ------------------------------------------------------------
;;                           Languages
;; ------------------------------------------------------------

(use-package go-mode
  :ensure t
  :config
  (setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save))

(use-package rust-mode
  :ensure t)

;; ------------------------------------------------------------
;;                           Custom Set
;; ------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("efc7ad88d2749efccf5a5188a8cc579b3d08893af14d45faced3e81418b58126" "1db4be958a1df556190253eaee2717c554402f93d96ff6ec9e206567d906817e" "f165fc99b4cb149324eea38f0df7cd2eb17df4ab6461b6cb79d1a949e85a50c5" default))
 '(package-selected-packages
   '(gotham-dark-theme evil-goggles beacon rust-mode go-mode exec-path-from-shell markdown-mode gotham-theme magit helm-swoop helm use-package evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))
