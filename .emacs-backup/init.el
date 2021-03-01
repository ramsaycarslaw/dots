;;;;;;;;;;;;;;;;;;;;;;;;
;; Package Handelling ;;
;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Not on SSL."))
  (setq default-directory "/Users/ramsaycarslaw/")
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

;;--------------------------------------------------------------------------------
;; Asynchronous Execution
;;--------------------------------------------------------------------------------
;; lets us use async process whenever possible
;; pretty good for speed etc
(use-package async
  :ensure t
  :init (dired-async-mode 1))

(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

;;--------------------------------------------------------------------------------
;; Emacs Specific Settings
;;--------------------------------------------------------------------------------

;; configure emacs specific settings
(use-package emacs
  :config
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

  ;;(set-frame-parameter (selected-frame) 'alpha '(90 80))
  ;;(add-to-list 'default-frame-alist '(alpha 90 80))
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
  
  (setq initial-frame-alist
            '(
              (width . 80) ; chars
              (height . 40) ; lines
              (left . 0)
              (top . 0)))

  (delete-selection-mode t)
  (global-visual-line-mode t)
  (show-paren-mode t)
  
  ;; make C-o behave like vim o
  (defun insert-new-line-below ()
    "Add a new line below the current line"
    (interactive)
    (let ((oldpos (point)))
      (end-of-line)
      (newline-and-indent)))
  (global-set-key (kbd "C-o") 'insert-new-line-below)
  
  (setq initial-scratch-message
	(concat
	 ";; \n"
	 ";; ▒█▀▀█ ▒█▀▀█ ▒█▀▀█\n"
	 ";; ▒█▄▄▀ ▒█░░░ ▒█░░░\n" 
	 ";; ▒█░▒█ ▒█▄▄█ ▒█▄▄█\n"
	 ";; \n"
	 ";; This buffer is for text that is not saved, and for Lisp evaluation.\n"
	 ";; To create a file, visit it with C-x C-f, and enter text in it's buffer\n"))
  ;; -- INIT --
  ;;init stuff!
  (setq ring-bell-function 'ignore
	inhibit-startup-message t
	frame-resize-pixelwise nil)
  (setq user-mail-address "ramsaycarslaw@icloud.com"
	user-full-name "Ramsay Carslaw")
  :bind
  ("s-r" . eval-buffer))

(use-package exec-path-from-shell
  :ensure t
  :config (when (memq window-system '(mac ns x))
	    (exec-path-from-shell-initialize))
  (setenv "GOPATH" "/Users/ramsaycarslaw/go"))

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

;;--------------------------------------------------------------------------------
;; Improved Text Editing
;;--------------------------------------------------------------------------------
;; refactor variable names etc
(use-package iedit
  :defer t
  :ensure t
  :bind
  ("M-;" . iedit-mode))

;; avy to jumpo to char
(use-package avy
  :ensure t
  :bind (("M-SPC" . 'avy-goto-char-timer)
	 ("C-x C-w" . 'avy-goto-word-0)
         ("C-x C-j" . 'avy-goto-line)))

;; complete brackets and so on
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; line numbers
(use-package display-line-numbers
  :ensure t
  :config
  (global-display-line-numbers-mode t))

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-.") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-*") 'mc/mark-all-like-this))

;; ------------------------------------------------------------
;;                   File Tree & Tablines
;; ------------------------------------------------------------

(use-package all-the-icons
  :ensure t)

(use-package neotree
  :ensure t
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-smart-open t)
  (global-set-key (kbd "s-b") 'neotree-toggle)
  (global-set-key [f8] 'neotree-toggle))

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
  :config (helm-mode 1))

(use-package helm-swoop
  :ensure t
  :demand t
  :bind (("\C-s" . helm-swoop)))

;; ------------------------------------------------------------
;;                           Magit
;; ------------------------------------------------------------

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  ("C-x M-g" . magit-dispatch))

;; ------------------------------------------------------------
;;                           Themes
;; ------------------------------------------------------------

(use-package emacs
  :init
  (set-face-attribute 'default nil :font "Fira Code 11")
  (set-frame-font "Fira Code 11" nil t)
  (global-visual-line-mode t)
  ;; Hashtag
  (when window-system (set-fringe-mode 0))
  (global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))
  (setq-default cursor-type 'bar)
  
  (setq display-time-24hr-format nil)
  (setq-default frame-title-format '("Emacs — %b"))
  (setq display-time-format "%H:%M - %d %B %Y"))

;; Turn off all the gui stuff we don't need
(use-package tool-bar
  :init (tool-bar-mode 0))

(when window-system (use-package scroll-bar
  :init (scroll-bar-mode 0)))

(use-package menu-bar
  :init (menu-bar-mode 1))

;; add a more modern modeline
(use-package doom-modeline
  :ensure t
  :demand t
  :init
  (doom-modeline-mode 1))

;; colored brackets
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; beacon shows where the cursor is when switching buffers
;; as part of this we also turn on hl line mode
(use-package beacon
  :ensure t
  :init
  (when window-system (add-hook 'prog-mode-hook 'hl-line-mode))
  (beacon-mode 1))

;; theme of choice
(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (doom-themes-neotree-config)
  (load-theme 'doom-rouge t))

(use-package gotham-theme
  :ensure t)

(use-package cyberpunk-theme
  :ensure t)

;; make buffers scale nicely
(use-package golden-ratio
  :ensure t
  :init (golden-ratio-mode t))

;; make the title bar much nicer
(use-package ns-auto-titlebar
  :ensure t
  :config
  (when (eq system-type 'darwin) (ns-auto-titlebar-mode)))

;; ------------------------------------------------------------
;;                             Company
;; ------------------------------------------------------------

;; -- LSP -- 

(use-package flycheck
  :ensure t)

(setenv "PATH" (concat (getenv "PATH") ":/Users/ramsaycarslaw/go/bin/gopls"))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook
  (rust-mode . lsp-deferred)
  (go-mode . lsp-deferred))

;;Optional - provides fancier overlays.

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
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
  :hook
  (lsp-mode . lsp-ui-mode))

;;Company mode is a standard completion package that works well with lsp-mode.
;;company-lsp integrates company mode completion with lsp-mode.
;;completion-at-point also works out of the box but doesn't support snippets.

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0
	company-show-numbers nil
	company-dabbrev-ignore-case 1
	company-selection-wrap-around t
	company-minimum-prefix-length 1
	company-tooltip-align-annotations t)

  :hook
  (prog-mode . company-mode))

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workplace-symbol)


;; fixed bugs ->
;; 1. customize-group RET company-box RET
;; 2. untick all atributes on company-box-scrollbar
(use-package company-box
  :ensure t
  :config
  (setq company-box-doc-enable nil)
  (setq company-box-icons-all-the-icons t)
  (setq company-box-scrollbar t)
  (setq company-box-backends-colors nil)
  (setq show-trailing-whitespace nil)
  :hook (company-mode . company-box-mode))

;; ------------------------------------------------------------
;;                             C
;; ------------------------------------------------------------

;; Use the ccls language server as a backend for completion etc
(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake 1)
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

;; set my default C style to that of Kernigahn and Ritchie
(setq c-default-style "linux")
(setq-default c-basic-offset 2)

;; ------------------------------------------------------------
;;                             Yas
;; ------------------------------------------------------------

;; yasnippet for code snippets
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

;; ------------------------------------------------------------
;;                             Go
;; ------------------------------------------------------------

;;Set up before-save hooks to format buffer and add/delete imports.
;;Make sure you don't have other gofmt/goimports hooks enabled.

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Go-Eldoc - really nice docs

(use-package go-eldoc
  :ensure t
  :requires go-mode
  :hook (go-mode . go-eldoc-setup))

(use-package go-mode
:ensure t
:ensure t
:mode ("\\.go\\'" . go-mode)
:bind (("M-," . compile)
       ("M-." . godef-jump)
       ("M-/" . 'pop-tag-mark)))

;; ------------------------------------------------------------
;;                           Haskell
;; ------------------------------------------------------------

(use-package haskell-mode
  :ensure t
  :hook
  (haskell-mode . interactive-haskell-mode))

;; ------------------------------------------------------------
;;                           LaTeX
;; ------------------------------------------------------------
;; We use aUcTeX as the backend for all TeX and LaTeX.

(use-package tex
  :ensure auctex
  :defer t
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t))

;; We also need spelling for latex to increase the quality of emacs as a word processor.

(use-package flyspell-mode
  :defer t
  :hook
  (text-mode . flyspell-mode)
  (tex-mode . flyspell-mode)
 (latex-mode . flyspell-mode))

;; ------------------------------------------------------------
;;                         Mt mode
;; ------------------------------------------------------------

(use-package mt-mode
  :load-path "site-lisp/mt-mode"
  :config
  (defun run-mt ()
    (interactive)
    (shell-command
     "mt"
     (current-buffer)))
  :interpreter "mt"
  :mode "\\.mt\\'")

;; ------------------------------------------------------------
;;                         Email
;; ------------------------------------------------------------

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
(require 'mu4e)

(setq mu4e-get-mail-command "mbsync icloud"
  mu4e-view-prefer-html t
  mu4e-update-interval 180
  mu4e-headers-auto-update t
  mu4e-compose-signature-auto-include nil
  mu4e-compose-format-flowed t)

(setq mu4e-maildir "~/Maildir")

(setq mu4e-sent-folder   "/icloud/Sent Messages"
        mu4e-drafts-folder "/icloud/Drafts"
        mu4e-trash-folder  "/icloud/Trash")

;; ------------------------------------------------------------
;;                     Nice Compile Window
;; ------------------------------------------------------------
;; These are a set of functions written to aid in compiling code, there includes bindings for all the languages I use bound to <f5>. 

(setq compilation-window-height 14)
(setq compilation-read-command nil)
(defun my-compilation-hook ()
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
	(let* ((w (split-window-vertically))
	       (h (window-height w)))
	  (select-window w)
	  (switch-to-buffer "*compilation*")
	  (shrink-window (- h compilation-window-height)))))))
(add-hook 'compilation-mode-hook 'my-compilation-hook)

(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)
(setq compilation-scroll-output t)

(use-package vterm
  :ensure t
  :bind ("<C-return>" . vterm))

(use-package org
  :config
  (electric-pair-mode 0)
  (setq doc-view-resolution 192)
  (require 'org-tempo))

(use-package hydra
  :ensure t
  :config
  (defhydra hydra-compile-menu (:color blue :hint nil)
"
^Run^             ^Build^           
^^^^^^^------------------------------
_m_: mt              _c_: C (single file)        
_p_: Python          _C_: C (make file)     
_g_: Go              _G_: Go 
_h_ Haskell (Run)    _H_: Haskell (Build)
"
("m" (shell-command (concat "mt " (buffer-name))))
("p" (shell-command (concat "python3 " (buffer-name))))
("g"  (shell-command "go run *.go"))
("c" (shell-command (concat "clang -o exec " (buffer-name))))
("C" (shell-command "make -k"))
("G" (shell-command "go build"))
("h" (shell-command (concat "runhaskell " (buffer-name))))
("H" (shell-command (concat "ghc" (buffer-name))))
)
  :bind
  ("<f5>" . hydra-compile-menu/body))

;; ------------------------------------------------------------
;;                         Ligatures!
;; ------------------------------------------------------------
;; These ligatures use the faster Regex Opt to make loading faster, presently these are set up for jetbrains mono.

(let ((ligatures `((?-  . ,(regexp-opt '("-|" "-~" "---" "-<<" "-<" "--" "->" "->>" "-->")))
                   (?/  . ,(regexp-opt '("/**" "/*" "///" "/=" "/==" "/>" "//")))
                   (?*  . ,(regexp-opt '("*>" "***" "*/")))
                   (?<  . ,(regexp-opt '("<-" "<<-" "<=>" "<=" "<|" "<||" "<|||::=" "<|>" "<:" "<>" "<-<"
                                         "<<<" "<==" "<<=" "<=<" "<==>" "<-|" "<<" "<~>" "<=|" "<~~" "<~"
                                         "<$>" "<$" "<+>" "<+" "</>" "</" "<*" "<*>" "<->" "<!--")))
                   (?:  . ,(regexp-opt '(":>" ":<" ":::" "::" ":?" ":?>" ":=")))
                   (?=  . ,(regexp-opt '("=>>" "==>" "=/=" "=!=" "=>" "===" "=:=" "==")))
                   (?!  . ,(regexp-opt '("!==" "!!" "!=")))
                   (?>  . ,(regexp-opt '(">]" ">:" ">>-" ">>=" ">=>" ">>>" ">-" ">=")))
                   (?&  . ,(regexp-opt '("&&&" "&&")))
                   (?|  . ,(regexp-opt '("|||>" "||>" "|>" "|]" "|}" "|=>" "|->" "|=" "||-" "|-" "||=" "||")))
                   (?.  . ,(regexp-opt '(".." ".?" ".=" ".-" "..<" "...")))
                   (?+  . ,(regexp-opt '("+++" "+>" "++")))
                   (?\[ . ,(regexp-opt '("[||]" "[<" "[|")))
                   (?\{ . ,(regexp-opt '("{|")))
                   (?\? . ,(regexp-opt '("??" "?." "?=" "?:")))
                   (?#  . ,(regexp-opt '("####" "###" "#[" "#{" "#=" "#!" "#:" "#_(" "#_" "#?" "#(" "##")))
                   (?\; . ,(regexp-opt '(";;")))
                   (?_  . ,(regexp-opt '("_|_" "__")))
                   (?\\ . ,(regexp-opt '("\\" "\\/")))
                   (?~  . ,(regexp-opt '("~~" "~~>" "~>" "~=" "~-" "~@")))
                   (?$  . ,(regexp-opt '("$>")))
                   (?^  . ,(regexp-opt '("^=")))
                   (?\] . ,(regexp-opt '("]#"))))))
  (dolist (char-regexp ligatures)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

(use-package composite
  ;; add languages you want ligatures for here
  ;; ligatures do NOT work with LSP mode
  :hook ((haskell-mode . auto-composition-mode)
	 (vterm-mode . auto-composition-mode))
  :init (global-auto-composition-mode -1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "dde8c620311ea241c0b490af8e6f570fdd3b941d7bc209e55cd87884eb733b0e" "d5a878172795c45441efcd84b20a14f553e7e96366a163f742b95d65a3f55d71" "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" "5036346b7b232c57f76e8fb72a9c0558174f87760113546d3a9838130f1cdb74" "74ba9ed7161a26bfe04580279b8cad163c00b802f54c574bfa5d924b99daa4b9" "8e959d5a6771b4d1e2177263e1c1e62c62c0f848b265e9db46f18754ea1c1998" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "37a4701758378c93159ad6c7aceb19fd6fb523e044efe47f2116bc7398ce20c9" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "188fed85e53a774ae62e09ec95d58bb8f54932b3fd77223101d036e3564f9206" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "4a8d4375d90a7051115db94ed40e9abb2c0766e80e228ecad60e06b3b397acab" default))
 '(package-selected-packages
   '(flymake-google-cpplint lsp-haskell frame-cmds multiple-cursors yasnippet-snippets vterm use-package rainbow-delimiters ns-auto-titlebar neotree magit lsp-ui iedit hydra helm-swoop helm-lsp haskell-mode gotham-theme golden-ratio go-eldoc flycheck exec-path-from-shell doom-themes doom-modeline cyberpunk-theme company-box ccls beacon avy auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
