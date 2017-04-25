
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

(global-set-key (kbd "C-n")
    (lambda () (interactive) (next-line 5)))

(global-set-key (kbd "C-p")
    (lambda () (interactive) (previous-line 5)))

(use-package drag-stuff
  :ensure t
  :diminish drag-stuff-mode
  :bind (("M-<down>" . drag-stuff-down)
         ("M-<up>" . drag-stuff-up))
  :config
  (drag-stuff-global-mode))

(use-package magit
  :bind (("C-x g" . magit-status))
  :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode))

(setq projectile-switch-project-action 'neotree-projectile-action)

(use-package neotree
  :ensure t)


(use-package exec-path-from-shell
  :ensure t
  :init (progn
	  (when (memq window-system '(mac ns x))
	    (exec-path-from-shell-initialize))
	  ))

(setq neo-smart-open t)

(use-package flycheck
  :ensure t
  :init (progn
	  (global-flycheck-mode t)
	  ))

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

;; (use-package elixir-mode
;;   :mode ("\\.ex\\'" "\\.exs\\'" "mix\\.lock\\'")
;;   :config)

(use-package alchemist
  :ensure t
  :config (progn
	    ;; (setq alchemist-goto-erlang-source-dir "~/projects/open-source/otp/")
	    (setq alchemist-goto-elixir-source-dir "/Users/nzo01/emacs_libs/elixir/")    
	    ;; (setq alchemist-key-command-prefix (kbd "C-c ,")) ;; default: (kbd "C-c a")
	    (setq alchemist-test-display-compilation-output t)
	    (setq alchemist-hooks-test-on-save nil)
	    (setq alchemist-hooks-compile-on-save nil)

	    ;; allows the jumping back out of erlang code
	    (defun custom-erlang-mode-hook ()
	      (define-key erlang-mode-map (kbd "M-,") 'alchemist-goto-jump-back))
	    (add-hook 'erlang-mode-hook 'custom-erlang-mode-hook)
	    ))

(use-package flycheck-mix
  :ensure t
  :config (progn
	    (flycheck-mix-setup)
	    ))


(use-package flycheck-mix
  :ensure t)

(use-package flycheck-elixir
  :ensure t)


(use-package elixir-mode
  :ensure t
  :init (progn
	  (add-hook 'elixir-mode-hook 'company-mode)
	  (add-hook 'elixir-mode-hook 'alchemist-mode)
	  (add-hook 'elixir-mode-hook 'elixir-add-electric-pairs)
	  (add-hook 'elixir-mode-hook 'flycheck-elixir)
	  (add-hook 'elixir-mode-hook 'flycheck-mode)
	  )
  )

(use-package wh-smarter-beginning-of-line
  :bind ("C-a" . wh/smarter-beginning-of-line))

;;
;; VISUAL CHANGES
;;

;; make the fringe stand out from the background
(setq solarized-distinct-fringe-background t)

;; Don't change the font for some headings and titles
(setq solarized-use-variable-pitch nil)

;; make the modeline high contrast
(setq solarized-high-contrast-mode-line t)

;; Use less bolding
(setq solarized-use-less-bold t)

;; Use more italics
(setq solarized-use-more-italic t)

;; Use less colors for indicators such as git:gutter, flycheck and similar
(setq solarized-emphasize-indicators nil)

;; Don't change size of org-mode headlines (but keep other size-changes)
(setq solarized-scale-org-headlines nil)

;; Avoid all font-size changes
(setq solarized-height-minus-1 1.0)
(setq solarized-height-plus-1 1.0)
(setq solarized-height-plus-2 1.0)
(setq solarized-height-plus-3 1.0)
(setq solarized-height-plus-4 1.0)

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

(set-frame-font "Inconsolata 15" t t)

;; for new frames and emacs client..
(setq default-frame-alist '((font . "Inconsolata 15")))

;; set font size
(set-face-attribute 'default nil :height 120)

;;(load-theme 'solarized-light t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(setq split-height-threshold nil)
(setq split-width-threshold 160)

;;
;; This stuff below is generated by emacs
;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(package-selected-packages
   (quote
    (drag-stuff exec-path-from-shell flycheck-elixir flycheck-mix flycheck alchemist solarized-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
