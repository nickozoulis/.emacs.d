
;;
;; PACKAGE INIT
;;

(require 'package)

(setq package-archives
      (append package-archives
              '(("melpa" . "http://melpa.milkbox.net/packages/"))))

(package-initialize)
(setq package-enable-at-startup nil)(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))


;; If never connected to repositories before, download package descriptions so
;; `use-package' can trigger installation of missing packages.
(unless package-archive-contents
  (message "Refreshing ELPA package archives...")
  (package-refresh-contents))


;; ...but before everything, make sure `use-package' is installed.
(unless (package-installed-p 'use-package)
  (message "`use-package' not found.  Installing...")
  (package-install 'use-package))

(require 'use-package)
(setq use-package-minimum-reported-time 0
      use-package-verbose t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))


;;
;; PACKAGES
;;

(use-package magit
  :bind (("C-x g" . magit-status))
  :ensure t)

(use-package solarized-theme
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode))

(use-package neotree
  :ensure t)

(setq neo-smart-open t)

(use-package erlang
  :ensure t
  ;; We need to specify erlang-mode explicitely as the package is not called
  ;; erlang-mode.
  :mode (("\\.erl\\'" . erlang-mode)
         ("\\.hrl\\'" . erlang-mode)
         ("\\.xrl\\'" . erlang-mode)
         ("sys\\.config\\'" . erlang-mode)
         ("rebar\\.config\\'" . erlang-mode)
         ("\\.app\\(\\.src\\)?\\'" . erlang-mode))
  :config
  (setq erlang-indent-level 4))
(use-package elixir-mode
  :mode ("\\.ex\\'" "\\.exs\\'" "mix\\.lock\\'")
  :config)

(use-package wh-smarter-beginning-of-line
  :bind ("C-a" . wh/smarter-beginning-of-line))

;;
;; VISUAL CHANGES
;;

;; Always as "y or n", not that annoying "yes or no".
(defalias 'yes-or-no-p 'y-or-n-p)

;; Disable toolbar
(tool-bar-mode -1)

;; solid cursor
(blink-cursor-mode 0)

;; disable scroll bar
(scroll-bar-mode -1)

;; no tool bar
(tool-bar-mode 0)

;; no menu bar
(menu-bar-mode 0)

;; no default start up screen
(setq inhibit-startup-screen t)

;; no initial scratch text
(setq initial-scratch-message nil)

;; buffer line spacing
(setq-default line-spacing 5)

;; display line numbers
(setq linum-format "%d ")
(global-linum-mode t)

;; window size
(setq initial-frame-alist '((top . 0) (left . 0) (width . 200) (height . 50)))
;; new window sizes
(setq default-frame-alist '((top . 0) (left . 0) (width . 200) (height . 50)))
;; width  -> num characters
;; height -> num lines

;; limit the number of times a frame can split
(setq split-width-threshold 200)

(set-frame-font "Inconsolata 13" t t)

;; for new frames and emacs client..
(setq default-frame-alist '((font . "Inconsolata 13")))

;; set font size
(set-face-attribute 'default nil :height 120)

(load-theme 'solarized-light t)


;;
;; This stuff below is generated by emacs
;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (solarized-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
