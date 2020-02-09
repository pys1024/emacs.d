;;; init-evil.el

(add-to-list 'load-path "~/.emacs.d/elpa-26.1/evil")
;;; config evil-leader
(require-package 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "." 'evil-scroll-page-down
  "," 'evil-scroll-page-up
  "<SPC>" 'execute-extended-command
  "<tab>" 'switch-to-buffer
  "!" 'shell-command
  ";" 'comment-line
  "/" 'helm-do-ag
  "tn" 'visual-line-mode
  "tw" 'whitespace-mode
  "thp" 'hightlight-phrase
  "thr" 'hightlight-regexp
  "thl" 'hightlight-lines-matching-regexp
  "0" 'select-window-0
  "1" 'select-window-1
  "2" 'select-window-2
  "3" 'select-window-3
  "ff" 'counsel-find-file
  "fs" 'save-buffer
  "bk" 'kill-buffer
  "bb" 'switch-to-buffer
  "pR" 'projectile-regenerate-tags
  "pj" 'projectile-find-tags
  "pf" 'projectile-find-file
  "pd" 'projectile-find-dir
  )
;;; remove default evil-toggle-key C-z, manually setup later
(setq evil-toggle-key "")
;;; don't bind [tab] to evil-jump-forward
(setq evil-want-C-i-jump nil)
(require-package 'evil)
(evil-mode 1)

;;; remove all keybindings from insert-state keymap, use emacs-state when edting
(setcdr evil-insert-state-map nil)

;;; ESC to switch back normal-state
(define-key evil-insert-state-map [escape] 'evil-normal-state)

;;; TAB to indent in normal-state
(define-key evil-normal-state-map (kbd "TAB") 'indent-for-tab-command)

(define-key evil-normal-state-map (kbd ",") 'scroll-down-line)
(define-key evil-normal-state-map (kbd ".") 'scroll-up-line)
(define-key evil-normal-state-map (kbd "M-.") 'xref-find-definitions)
(define-key evil-normal-state-map (kbd "C-r") 'isearch-backward)

;;; user j/k to move one visual line instead of gi/gk
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>")
    'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>")
  'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>")
  'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>")
  'evil-previous-visual-line)
  
;; (set evil-default-state 'emacs)
(setq evil-default-state 'normal)

(provide 'init-evil)
