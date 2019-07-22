;;; init-local --- my configuration
;;; Commentary:
;;; pys1024 2018/12/26

;;; Code:
(defun decrypt-file ()
  "Decrypt file."
  (interactive)
  (shell-command (concat "cat "
                         (buffer-file-name)
                         " > tmp;mv tmp "
                         (buffer-file-name)
                         ";rm -f tmp"))
  (revert-buffer t t t))

(defun refresh-file ()
  "Refresh file."
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
  "Go to other window."
  (interactive)
  (other-window 1))

(setq gdb-many-windows nil)

(defun set-gdb-layout (&optional c-buffer)
  (if (not c-buffer)
      (setq c-buffer (window-buffer (selected-window)))) ;; save current buffer
  ;; from http://stackoverflow.com/q/39762833/846686
  (set-window-dedicated-p (selected-window) nil) ;; unset dedicate state if needed
  (switch-to-buffer gud-comint-buffer)
  (delete-other-window) ;; clean all
  
  (let* (
         (w-gdb (selected-window))
         (w-source (split-window w-gdb (floor (/ (* (window-height) 1) 3))
                                 'below))
         (w-stack (split-window w-source nil
                                'below))
         (w-locals (split-window w-gdb nil 'right))
         (w-disass (split-window w-source nil 'right))
         (w-break (split-window w-stack nil
                                'right))
         (w-io (split-window w-break nil 'below))
         )
        (set-window-buffer w-io (gdb-get-buffer-create 'gdb-inferior-io))
        (set-window-dedicated-p w-io t)
        (set-window-buffer w-break (gdb-get-buffer-create 'gdb-breakpoints-buffer))
        (set-window-dedicated-p w-break t)
        (set-window-buffer w-locals (gdb-get-buffer-create 'gdb-registers-buffer))
        (set-window-dedicated-p w-locals t)
        (set-window-buffer w-stack (gdb-get-buffer-create 'gdb-stack-buffer))
        (set-window-dedicated-p w-stack t)
        (set-window-buffer w-disass (gdb-get-buffer-create 'gdb-dissassembly-buffer))
        (set-window-dedicated-p w-disass t)
        
        (set-window-buffer w-gdb gud-comint-buffer)
        
        (select-window w-gdb)
        (set-window-buffer w-source c-buffer)
        
        ))

(defadvice gdb (around args activate)
  "Change the way to gdb works."
  (setq global-config-editing (current-window-configuration)) ;; to restore: (set-window-configuration c-editing
  (let (
        (c-buffer (window-buffer (selected-window))) ;; save current buffer
        )
       ad-do-it
       (set-gdb-layout c-buffer))
  )
(defadvice gdb-reset (around args activate)
  "Change the way to gdb exit."
  ad-do-it
  (set-window-configuration global-config-editing))

;; global set key
(global-set-key (kbd "M-s r") 'refresh-file)
(global-set-key (kbd "C-x r") 'execute-this-buffer)
(global-set-key (kbd "C-<tab>") 'go-to-other-window)
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)
(global-set-key (kbd "C-,") 'scroll-down-line)
(global-set-key (kbd "C-.") 'scroll-up-line)

(define-key visual-line-mode-map [remap kill-line] nil)
(define-key visual-line-mode-map [remap move-beginning-of-line] nil)
(define-key visual-line-mode-map [remap move-end-of-line] nil)

;; global set variables
(setq-default cursor-type 'bar)
;; ;;(global-hl-line-mode t)
(set-cursor-color "#ff0000")
(global-linum-mode 1)
(global-visual-line-mode t)
;;
(size-indication-mode 1)
(setq-default projectile-tags-backend 'ggtags)
;;
;;
;;
;; (set-face-attribute 'default nil :height 130)
(delete-selection-mode 1)
(set-frame-font "Courier New-13")
(setq shell-file-name "bash")
;; (set-variable 'shell-command-switch "-c")
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)


;;(my-max-window)
(setq initial-frame-alist '((fullscreen . maximized)))
(add-to-list 'display-buffer-alist
             '("^\\*shell\\*$" . (display-buffer-same-window)))
;; (put 'dired-find-alternate-file 'disabled nil)
;; (with-eval-after-load 'dired
;;   (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;; ;;
;; (fset 'yes-or-no-p 'y-or-n-p)
;; (require 'expand-region)
;; (global-set-key (kbd "C-=") 'er/expand-region)

(require 'iedit)
(require-package 'helm-ag)
(require 'window-numbering)
(require 'company-tabnine)
(add-to-list 'company-backend #'company-tabnine)
(window-numbering-mode)

;; Trigger completion immediately.
(setq company-idle-delay 0)

;; Number the candidates (use M-1, M-2 etc to select completions).
(setq company-show-numbers t)

;; Use the tab-and-go frontend.
;; Allows TAB to select and complete at the same time.
(company-tng-configure-default)
(setq company-frontends
      '(company-tng-frontend
        company-pseudo-tooltip-frontend
        company-echo-metadata-frontend))

;; ;;
;; (global-auto-revert-mode 1)
;; (setq auto-save-default nil)
;; (require 'popwin)
;; (popwin-mode 1)
;; (setq ring-bell-function 'ignore)
(setq make-backup-files nil)
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
(require 'comint)
(set-face-attribute 'comint-highlight-prompt nil :inherit nil)
(provide 'init-local)
;;; init-local ends here
