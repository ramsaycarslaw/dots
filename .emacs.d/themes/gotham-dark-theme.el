;;; gotham-dark-theme.el --- gotham-dark
;;; Version: 1.0
;;; Commentary:
;;; A theme called gotham-dark
;;; Code:

(deftheme gotham-dark "DOCSTRING for gotham-dark")
  (custom-theme-set-faces 'gotham-dark
   '(default ((t (:foreground "#93cac8" :background "#000000" ))))
   '(cursor ((t (:background "#fdf4c1" ))))
   '(fringe ((t (:background "#282828" ))))
   '(mode-line ((t (:foreground "#5e45d0" :background "#000000" ))))
   '(region ((t (:background "#504945" ))))
   '(secondary-selection ((t (:background "#6248d6" ))))
   '(font-lock-builtin-face ((t (:foreground "#245361" ))))
   '(font-lock-comment-face ((t (:foreground "#5e44d2" ))))
   '(font-lock-function-name-face ((t (:foreground "#34869d" ))))
   '(font-lock-keyword-face ((t (:foreground "#ecb44b" ))))
   '(font-lock-string-face ((t (:foreground "#bf2f26" ))))
   '(font-lock-type-face ((t (:foreground "#4c4f61" ))))
   '(font-lock-constant-face ((t (:foreground "#505367" ))))
   '(font-lock-variable-name-face ((t (:foreground "#28a98b" ))))
   '(minibuffer-prompt ((t (:foreground "#34869d" :bold t ))))
   '(font-lock-warning-face ((t (:foreground "red" :bold t ))))
   )

;;;###autoload
(and load-file-name
    (boundp 'custom-theme-load-path)
    (add-to-list 'custom-theme-load-path
                 (file-name-as-directory
                  (file-name-directory load-file-name))))
;; Automatically add this theme to the load path

(provide-theme 'gotham-dark)

;;; gotham-dark-theme.el ends here
