
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

(global-set-key (kbd "C-<down>")
    (lambda () (interactive) (next-line 5)))

(global-set-key (kbd "C-<up>")
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


(use-package alchemist
 :ensure t
 :config (progn
        (setq alchemist-goto-elixir-source-dir "/Users/nzo01/emacs_libs/elixir/")
        ;; (setq alchemist-key-command-prefix (kbd “C-c ,“)) ;; default: (kbd “C-c a”)
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

(use-package company
 :ensure t
 :config (progn
        (add-hook 'after-init-hook 'global-company-mode)))


(use-package elixir-mode
  :mode "\\.ex\\'"
  :ensure t
  :init (progn
	  (add-hook 'elixir-mode-hook 'company-mode)
	  (add-hook 'elixir-mode-hook 'alchemist-mode)
	  ;; (add-hook 'elixir-mode-hook 'elixir-add-electric-pairs)
	  ;; (add-hook 'elixir-mode-hook 'flycheck-elixir)
	  (add-hook 'elixir-mode-hook 'flycheck-mode)
	  )
  )

(use-package yasnippet
  :ensure t
  :init (progn
          (yas-global-mode 1))
  :config (progn
            (yas-reload-all)
            (add-hook 'prog-mode-hook 'yas-minor-mode)
	    )
  )

(use-package neotree
  :ensure t
  :init (progn
	  (setq neo-hidden-regexp-list '("\\.beam$" "\\#$" "\\~$" "\\.git$" "\\.saves$"))
	  ))



(use-package wh-smarter-beginning-of-line
  :bind ("C-a" . wh/smarter-beginning-of-line))

(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)

;; typed text replaces selected
(delete-selection-mode 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq backup-directory-alist `(("." . ,"~/.emacs.d/.saves")))

;; Emacs auto-refresh all buffers when files have changed on disk
(global-auto-revert-mode t)

;; prefer spaces over tabs
(setq-default indent-tabs-mode nil)

;; Mousewheel scrolling can be quite annoying, lets fix it to scroll smoothly.
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

(use-package ivy
  :ensure t)

(use-package counsel
  :ensure t
  :bind
  (("M-x" . counsel-M-x)
   ("M-y" . counsel-yank-pop)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line)))

;; grep git files
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
         ;;("C-x C-f" . counsel-find-file)
         ("M-i" . counsel-imenu)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
         ("C-c l" . counsel-locate)
         ("C-c h f" . counsel-describe-function)
         ("C-c h v" . counsel-describe-variable)
         ("C-c i u" . counsel-unicode-char)
         ))

(use-package counsel-projectile
  :ensure t
  :config
  (counsel-projectile-on))


;; Move windows with Shift and arrow
(windmove-default-keybindings)


;; Fuzzy file find using fiplr
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(global-set-key (kbd "C-x d") 'fiplr-find-directory)
(setq fiplr-root-markers '(".git"))
(setq fiplr-ignored-globs '((directories (".git" ".svn" "deps" "_build"))
                            (files ("*.jpg" "*.png" "*.zip" "*~" "*#" "*.beam"))))


(require 'swoop)
(global-set-key (kbd "C-o")   'swoop)
(global-set-key (kbd "C-M-o") 'swoop-multi)
(global-set-key (kbd "M-o")   'swoop-pcre-regexp)
(global-set-key (kbd "C-S-o") 'swoop-back-to-last-position)
(setq swoop-window-split-current-window: t)
(setq swoop-window-split-direction: 'split-window-vertically)

;; EVIL MODE
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

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
(setq-default line-spacing 1)

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
;;(setq split-width-threshold 200)

(set-frame-font "Inconsolata 15" t t)

;; for new frames and emacs client..
(setq default-frame-alist '((font . "Inconsolata 15")))

;; set font size
(set-face-attribute 'default nil :height 120)

(load-theme 'dracula t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(setq split-height-threshold nil)
(setq split-width-threshold 160)

;; resize minibuffer size
;;(setq resize-mini-windows nil)
(setq max-mini-window-height 0.3)

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
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (rainbow-delimiters rainbow-blocks swoop project-explorer fiplr yasnippet use-package solarized-theme neotree magit flycheck-mix flycheck-elixir exec-path-from-shell erlang drag-stuff darcula counsel-projectile alchemist))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
