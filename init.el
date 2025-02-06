;; Cleaner GUI
(unless (eq system-type 'darwin)
  (menu-bar-mode -1))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; Package init.
(setq package-check-signature nil)
(require 'package)

(unless (bound-and-true-p package--initialized)
  (package-initialize))

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; reload emacs configuration showrtcut.
(defun reload-init-file ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c r") 'reload-init-file)

;; evil undo
(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

(setq lazy-highlight t                 ; highlight occurrences
      lazy-highlight-cleanup nil       ; keep search term highlighted
      lazy-highlight-max-at-a-time nil ; all occurences in file
      isearch-allow-scroll t           ; continue the search even though we're scrolling
      )

;; search no delay.
(setq lazy-highlight-initial-delay 0)
(setq lazy-highlight-interval 0)

(setq package-archives '(
    ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/") 
    ("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
    ("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")))

(use-package unicode-fonts)
(unicode-fonts-setup)

;; evil mode
(use-package evil
  :config
  (evil-mode 1))
(evil-select-search-module 'evil-search-module 'evil-search)
;; work with evil
(use-package better-jumper
  :config
  (better-jumper-mode 1))

(use-package evil-escape
  :config
  (evil-escape-mode 1)
	(setq-default evil-escape-key-sequence "fd")
)

(use-package tramp)
(setq tramp-default-method "plink")

(use-package goto-chg)
(global-set-key (kbd "M-i") 'goto-last-change-reverse)
(global-set-key (kbd "M-o") 'goto-last-change)
(global-set-key (kbd "C-g") 'projectile-grep)
(global-set-key (kbd "<f5>") 'revert-buffer)

(use-package topspace
  :config
  (global-topspace-mode 1))

;; Search string in windows-nt systems.
(when (eq system-type 'windows-nt)
  (with-eval-after-load 'grep
    ;; findstr can handle the basic find|grep use case
    (grep-apply-setting 'grep-find-template
                        "findstr /S /N /D:. /C:<R> <F>")
    (setq find-name-arg nil)))

(defun powershell ()
  "Run powershell"
  (interactive)
  (async-shell-command "c:/windows/system32/WindowsPowerShell/v1.0/powershell.exe"
               nil
               nil))

;; word expansion must be case sensitive!!!
(setq dabbrev-case-fold-search nil)
(setq indent-tabs-mode nil)


;; don't create temporal files in my folders!
(setq make-backup-files nil)
;; and undo tree record files
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; or, if it gets really annoying, we can just get rid of undo-tree temporal files!
;; (setq undo-tree-auto-save-history nil)

;; don't recenter when the cursor move out of window
(setq scroll-conservatively 101)
;; scroll margin, we need set the margin to 0 for topspace to work properly...
(setq scroll-margin 0)

;; c-like lang indent length is 4.
(setq-default c-basic-offset 4)
;; (setq-default evil-shift-width 2)

;; disable sound
(setq ring-bell-function 'ignore)
(abbrev-mode -1)

;; diable auto indent
(electric-indent-mode 0)

;; auto indent only for return!
(define-key global-map (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-x <down>") 'switch-to-buffer)
;; specifically for linux
(global-set-key (kbd "C-x C-k") 'kill-current-buffer)
(global-set-key (kbd "C-x C-j") 'switch-to-buffer)
(global-set-key (kbd "M-j") (kbd "<down>"))
(global-set-key (kbd "M-h") (kbd "<left>"))
(global-set-key (kbd "M-k") (kbd "<up>"))
(global-set-key (kbd "M-l") (kbd "<right>"))

;; hilight current line
(global-hl-line-mode 1)

(define-key key-translation-map (kbd "ESC") (kbd "C-g"))
(define-key key-translation-map (kbd "C-d") (kbd "C-x"))
;; specifically for linux
(define-key key-translation-map (kbd "C-h") (kbd "DEL"))
(define-key key-translation-map (kbd "C-j") (kbd "<down>"))
(define-key key-translation-map (kbd "C-k") (kbd "<up>"))

;; evil keybindings
;; (define-key evil-motion-state-map (kbd "C-x C-j") 'switch-to-buffer)
(define-key evil-motion-state-map (kbd "C-x <down>") 'switch-to-buffer)
(define-key evil-motion-state-map (kbd "C-e") 'evil-window-next)
(define-key evil-motion-state-map (kbd "C-x C-x") 'projectile-find-file)
(define-key evil-motion-state-map (kbd "C-x <up>") 'kill-current-buffer)
(define-key evil-normal-state-map (kbd "K") 'evil-scroll-line-up)
(define-key evil-normal-state-map (kbd "J") 'evil-scroll-line-down)
(define-key evil-motion-state-map (kbd "C-u") 'evil-ex-nohighlight)
(define-key evil-normal-state-map (kbd "z") 'evil-scroll-line-to-center)
(define-key evil-normal-state-map (kbd "<") 'evil-shift-left-line)
(define-key evil-normal-state-map (kbd ">") 'evil-shift-right-line)

;; Remove Evil's default binding
(define-key evil-normal-state-map (kbd "C-p") nil)
(define-key evil-insert-state-map (kbd "C-p") nil)
(define-key evil-visual-state-map (kbd "C-p") nil)
;; Bind globally
(global-set-key (kbd "C-p") 'switch-to-buffer)

;; theme
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

(use-package which-key
  :config
  (which-key-mode 1))

(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

;; set control and meta key
(setq mac-command-modifier 'control)
(setq mac-option-modifier 'meta)

(use-package flx-ido
  :config
  (ido-mode 1)
  (ido-everywhere)
  (flx-ido-mode))

(use-package go-mode)

;; disable wrap
(set-default 'truncate-lines t)
(setq hscroll-margin 1)
(setq hscroll-step 1)
;; wrap word for better formatting
;; (global-visual-line-mode t)

;; auto sync disk files
(global-auto-revert-mode 1)

;; set encoding
(set-language-environment "UTF-8")

;; set cursor style (this only works in GUI mode?)
(setq evil-normal-state-cursor '(box "#03fc17")
      evil-insert-state-cursor '(bar "#03fc17")
      evil-visual-state-cursor '(hollow "#03fc17"))

;; jump cursor to previous and next position the "vim" way
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "C-o") 'better-jumper-jump-backward)
  (define-key evil-motion-state-map (kbd "C-i") 'better-jumper-jump-forward))

;; map "j" and "k" to "gj" and "gk"
(define-key evil-motion-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "k") 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "Q") 'evil-invert-char)
(define-key evil-motion-state-map (kbd ";") 'evil-end-of-line)
(define-key evil-motion-state-map (kbd "C-;") 'evil-jump-item)
;; (define-key evil-normal-state-map (kbd "J") 'evil-percentage-of-line)

;; disable displaying line number to increase the performance (don't know if this really works)
(setq display-line-numbers-type nil)

;; (set-frame-font "PT Mono 15")
;; (set-frame-font "Andale Mono 15")
;; (set-frame-font "Monaco 15")

;; remember to first download the font on windows systems.
(when (eq system-type 'darwin)
  (set-frame-font "Menlo 16"))
(when (eq system-type 'windows-nt)
  (set-frame-font "Menlo 12"))
(global-font-lock-mode 0)

;; set not showing parenthesis pair matching
(setq-default show-paren-data-function #'ignore)
(show-paren-mode)

;; set hilight of current matching string
(set-face-attribute 'lazy-highlight nil :foreground "snow" :background "peru")
(set-face-attribute 'isearch nil :foreground "red" :background "yellow")
;; set selected text highlight
(set-face-attribute 'region nil :background "#083ed1")
;; (set-face-attribute 'region nil :foreground "black" :background "white")

;; comment code
(define-key evil-motion-state-map (kbd "C-/") 'comment-line)
;; this makes sure that C-/ will not affect undo-tree
(with-eval-after-load 'undo-tree (defun undo-tree-overridden-undo-bindings-p () nil))
;; don't pop up some strange minibuffer, please!
(define-key evil-motion-state-map (kbd "K") nil)

;; disable new line continue comment. I comment when I want to comment!
(setq +default-want-RET-continue-comments nil)
(setq +evil-want-o/O-to-continue-comments nil)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(isearch-hide-immediately t)
 '(package-selected-packages
    '(unicode-fonts evil-escape ssh ag frame-purpose topspace goto-chg go-mode helm undo-tree counsel ivy projectile better-jumper zenburn-theme use-package evil))
 '(read-file-name-completion-ignore-case nil)
 '(tab-width 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )