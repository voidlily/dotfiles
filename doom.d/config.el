;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; looking for something that looks good and has ligatures
;; <= != >=
;; current options:
;; Source Code Pro 14
;; SauceCodePro Nerd Font 14
;; Hasklug Nerd Font 14 - same as source code pro but with (a few) ligatures
;; FiraCode Nerd Font 13 - many ligature
;; JetBrainsMono Nerd Font 13 - default used in ghostty
;; Iosevka Nerd Font 15 - similar to pragmata
(setq doom-font (font-spec :family "Hasklug Nerd Font" :size 14 :weight 'normal))
;;(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 13 :weight 'normal))
;;(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 15 :weight 'normal))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-dark)
;; use M-x describe-char to find what faces affect it
;; other note, minibuffer appears "darker" because of solaire-mode
;; https://github.com/hlissner/emacs-solaire-mode
(custom-set-faces!
  `(default (t (:background ,(doom-color 'bg))))
  `(hl-line (t (:background ,(doom-color 'base0))))
  `(link (t (:foreground ,(doom-color 'yellow))))
  ;; default is this ugly magenta
  `(font-lock-constant-face (t (:foreground ,(doom-color 'blue) :bold nil)))
  ;; swap to yellow because property-use changed to blue below
  `(font-lock-number-face (t (:foreground ,(doom-color 'yellow))))
  ;; no clue why properties are yellow, i prefer blue
  `(font-lock-property-name-face (t (:foreground ,(doom-color 'blue))))
  `(font-lock-property-use-face (t (:foreground ,(doom-color 'blue))))
  ;; no clue why the ugly red in the faces
  ;; TODO in emacs 31 when markdown supports tree-sitter well, revisit
  `(markdown-header-face (t (:foreground ,(doom-color 'blue) :bold nil)))
  `(markdown-list-face (t (:foreground ,(doom-color 'blue) :bold nil))))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
(with-eval-after-load 'diff-hl
  (setq diff-hl-side 'right))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
(map! :i "C-y" 'clipboard-yank)
(map! :n "g j" 'evil-next-visual-line)
(map! :n "g k" 'evil-previous-visual-line)
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook! 'prog-mode-hook #'goto-address-prog-mode)
(add-hook! 'text-mode-hook #'goto-address-mode)
(add-hook! 'prog-mode-hook #'bug-reference-prog-mode)
(+global-word-wrap-mode +1)
