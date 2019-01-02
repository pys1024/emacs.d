;;; init-local --- my configuration
;;; Commentary:
;;; pys1024 2018/12/26

;;; Code:
;; (load-theme 'wombat t)

;; (prefer-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)

;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (package-initialize)

;; function define
;; (defun my-max-window()
;;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
;;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
;; ;;(run-with-idle-timer 0.01 nil 'my-max-window)

(defun refresh-file ()
  (interactive)
  (revert-buffer t (not (buffer-modified-p)) t))

(defun execute-this-buffer()
  "Execute buffer that visited now."
  (interactive)
  (if (string= (file-name-extension buffer-file-name) '"sh")
      (sh-execute-region (point-min) (point-max))
    (progn (eval-buffer nil (get-buffer-create "output"))
           (switch-to-buffer-other-window "output")
           (other-window 1))))

(defun go-to-other-window ()
  (interactive)
  (other-window 1))

;; global set key
(global-set-key (kbd "M-s r") 'refresh-file)
;; (global-set-key (kbd "C-<f7>") 'eval-this-buffer)
(global-set-key (kbd "C-x r") 'execute-this-buffer)
(global-set-key (kbd "C-<tab>") 'go-to-other-window)
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)

;; global set variables
(setq-default cursor-type 'bar)
;; ;;(global-hl-line-mode t)
(set-cursor-color "#ff0000")
(global-linum-mode 1)
(global-visual-line-mode t)
;;
(size-indication-mode 1)
;;
;;
;;
(set-face-attribute 'default nil :height 130)
(delete-selection-mode 1)
;; (set-variable 'shell-command-switch "-c")


;;(my-max-window)
(setq initial-frame-alist '((fullscreen . maximized)))

;; (put 'dired-find-alternate-file 'disabled nil)
;; (with-eval-after-load 'dired
;;   (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;; ;;
;; (fset 'yes-or-no-p 'y-or-n-p)
;; (require 'expand-region)
;; (global-set-key (kbd "C-=") 'er/expand-region)

(require 'iedit)
(require 'helm-ag)
(require 'window-numbering)
(window-numbering-mode)
;; ;;
;; (global-auto-revert-mode 1)
;; (setq auto-save-default nil)
;; (require 'popwin)
;; (popwin-mode 1)
;; (setq ring-bell-function 'ignore)
;; (setq make-backup-files nil)
;; (require 'dired-x)
;; (sp-local-pair '(emacs-lisp-mode emacs-interaction-mode) "'" nil :action nil)

;; (define-advice show-paren-function (:around (fn) fix-show-paren-function)
;; "Highlight enclosing parens."
;; (cond ((looking-at-p "\\s(") (funcall fn))
;; (t save-excursion
;; (ignore-errors (backward-up-list))
;; (funcall fn))))

;;(setq auto-mode-alist
;;      (append
;;      '(("\\.js\\'" . js2-mode))
;;      '(("\\.html\\'" . web-mode))
;;      auto-mode-alist))
;;      (require-package )

(provide 'init-local)
;;; init-local ends here
