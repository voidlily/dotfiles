(require 'cl)
(setenv "EDITOR" "emacsclient")
;; mac=dumb
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "LD_LIBRARY_PATH"))

(setq comint-buffer-maximum-size 1024)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "501caa208affa1145ccbb4b74b6cd66c3091e41c5bb66c677feda9def5eab19c" "54d1bcf3fcf758af4812f98eb53b5d767f897442753e1aa468cfeb221f8734f9" "1440d751f5ef51f9245f8910113daee99848e2c0" "485737acc3bedc0318a567f1c0f5e7ed2dfde3fb" "1f392dc4316da3e648c6dc0f4aad1a87d4be556c" default)))
 '(evil-want-C-u-scroll t)
 '(hippie-expand-try-functions-list (quote (yas/hippie-try-expand try-complete-file-name try-expand-all-abbrevs try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-lisp-symbol-partially try-complete-lisp-symbol)))
 '(ns-command-modifier nil)
 '(smart-tab-using-hippie-expand t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((((background dark)) (:foreground "red"))))
 '(rainbow-delimiters-depth-2-face ((((background dark)) (:foreground "orange"))))
 '(rainbow-delimiters-depth-3-face ((((background dark)) (:foreground "yellow"))))
 '(rainbow-delimiters-depth-4-face ((((background dark)) (:foreground "green"))))
 '(rainbow-delimiters-depth-5-face ((((background dark)) (:foreground "cyan"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "magenta"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "brown"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "#90a890"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "#a2b6da"))))
 '(rainbow-delimiters-unmatched-face ((((background dark)) (:background "red" :foreground "white"))))
 '(whitespace-tab ((t (:background "red2" :foreground "#dc322f" :weight bold)))))

;; Add marmalade repos
(require 'package)
(add-to-list 'package-archives
             ;'("marmalade" . "http://marmalade-repo.org/packages/")
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; ruby-electric is missing?
(defvar my-packages '(starter-kit
                      starter-kit-lisp
                      starter-kit-ruby
                      starter-kit-bindings
                      evil
                      undo-tree
                      smex
                      rainbow-delimiters
                      paredit
                      solarized-theme
                      smart-tab
                      smart-tabs-mode
                      hippie-expand-slime
                      ruby-mode
                      ruby-end
                      rainbow-mode
                      markdown-mode
                      yaml-mode
                      yasnippet
                      haskell-mode
                      coffee-mode
                      clojure-mode
                      clojure-test-mode
                      cider
                      exec-path-from-shell))
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Snippets
(require 'yasnippet)
;(yas/load-directory "~/.emacs.d/elpa/yasnippet-0.8.0/snippets")
(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)
(yas/global-mode 1)

;; Set up the Common Lisp environment
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq inferior-lisp-program "/usr/bin/env sbcl")
(require 'slime)
(slime-setup '(slime-fancy))

(global-rainbow-delimiters-mode 1)
(global-undo-tree-mode 1)
(require 'smart-tab)
(global-smart-tab-mode 1)
(global-auto-revert-mode 1)

(evil-mode 1)

(desktop-save-mode 1)

(tool-bar-mode -1)
(load-theme 'solarized-dark)

;; Use smex for M-x
(global-set-key [(meta x)] (lambda ()
                             (interactive)
                             (or (boundp 'smex-cache)
                                 (smex-initialize))
                             (global-set-key [(meta x)] 'smex)
                             (smex)))

(global-set-key [(shift meta x)] (lambda ()
                                   (interactive)
                                   (or (boundp 'smex-cache)
                                       (smex-initialize))
                                   (global-set-key [(shift meta x)] 'smex-major-mode-commands)
                                   (smex-major-mode-commands)))

(defun set-up-slime-hippie-expand-fuzzy ()
  (set-up-slime-hippie-expand t))

;; Starter kit has hl-mode and uses it as a hook, that's stupid
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)
(remove-hook 'prog-mode-hook 'esk-idle-highlight-mode)
(dolist (hook '(lisp-mode-hook
                elisp-mode-hook
                ruby-mode-hook
                prog-mode-hook
                c-mode-common-hook))
  (add-hook hook 'flyspell-prog-mode))

(dolist (ruby-fn '(ruby-end-mode))
  (add-hook 'ruby-mode-hook ruby-fn))

(add-hook 'slime-mode-hook 'set-up-slime-hippie-expand)
(add-hook 'slime-repl-mode-hook 'set-up-slime-hippie-expand)

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . ruby-mode))

;; Change starter kit defaults
(setq ring-bell-function nil
      visible-bell nil
      sentence-end-double-space nil
      mouse-yank-at-point nil)

;; auto-indent by default
(define-key global-map "\C-m" 'newline-and-indent)
(global-set-key "\r" 'newline-and-indent)

; don't indent ruby stupidly
(setq-default ruby-deep-indent-paren nil)
(setq-default ruby-deep-indent-paren-style nil)
(setq-default ruby-deep-arglist nil)

;; Evil modes
(add-to-list 'evil-emacs-state-modes
             'nrepl-mode
             'cider-repl-mode)
(define-key evil-normal-state-map "\C-y" 'yank)
(define-key evil-insert-state-map "\C-y" 'yank)
(define-key evil-visual-state-map "\C-y" 'yank)
(define-key evil-normal-state-map "\C-k" 'paredit-kill)
(define-key evil-insert-state-map "\C-k" 'paredit-kill)
(define-key evil-visual-state-map "\C-k" 'paredit-kill)

;; Prevent Emacs from extending file when
;; pressing down arrow at end of buffer.
(setq next-line-add-newlines nil)
;; Silently ensure newline at end of file
;; (setq require-final-newline t)
;; or make Emacs ask about missing newline
(setq require-final-newline nil)

;; Show and delete trailing whitespace
(setq-default show-trailing-whitespace t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; cheetah mode
(define-derived-mode cheetah-mode html-mode "Cheetah"
  (make-face 'cheetah-variable-face)
  (font-lock-add-keywords
   nil
   '(
     ("\\(#\\(from\\|else\\|include\\|extends\\|set\\|def\\|import\\|for\\|if\\|end\\)+\\)\\>" 1 font-lock-type-face)
     ("\\(#\\(from\\|for\\|end\\)\\).*\\<\\(for\\|import\\|def\\|if\\|in\\)\\>" 3 font-lock-type-face)
     ("\\(##.*\\)\n" 1 font-lock-comment-face)
     ("\\(\\$\\(?:\\sw\\|}\\|{\\|\\s_\\)+\\)" 1 font-lock-variable-name-face))
   )
  (font-lock-mode 1)
  (setq indent-tabs-mode 1)
  (setq tab-width 4))
(add-to-list 'auto-mode-alist '("\\.tmpl\\'" . cheetah-mode))

(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))

;; yelp tabs
(add-to-list 'load-path "~/.emacs.d/scripts")
(require 'smart-tabs-mode)
(smart-tabs-advice python-indent-line python-indent-offset)
(defun my-yelp-python-mode-hook ()
	  (setq tab-width 4)
	  (setq py-indent-offset 4)
          (let ((yelp-project-p (and buffer-file-name (or (string-match "/pg/yelp-main/" (buffer-file-name))
                                                          (string-match "/pg/yelp_conn/" (buffer-file-name))
                                                          (string-match "/pg/yelp_lib/" (buffer-file-name))
                                                          (string-match "/pg/yelp_logging/" (buffer-file-name))
                                                          (string-match "/pg/yelp_gearman/" (buffer-file-name))
                                                          (and (string-match "/pg/services/" (buffer-file-name))
                                                               (not (or (string-match "/zygote/" (buffer-file-name))
                                                                        (string-match "/google/" (buffer-file-name)))))))))
        (when yelp-project-p
          (setq indent-tabs-mode yelp-project-p)
          (smart-tabs-mode)))

	  (setq-default show-trailing-whitespace t)
	  (add-hook 'before-save-hook 'delete-trailing-whitespace)

	  (message "yelp python mode, tabs is %s" indent-tabs-mode))

(add-hook 'python-mode-hook 'my-yelp-python-mode-hook)
