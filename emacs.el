(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; my own plugin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/xueliang/")
(load "xueliang-git.elc");

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============evil-config=============())
(require 'evil)
(evil-mode 1)

;; Evil Mode everywhere.
(setq evil-emacs-state-modes nil)
(setq evil-insert-state-modes nil)
(setq evil-motion-state-modes nil)

(require 'evil-leader)
(global-evil-leader-mode)

(setq evil-shift-width 2)

(setq-default xueliang-leader-key "<SPC>")
(evil-leader/set-leader xueliang-leader-key)
(evil-leader/set-key
	"<SPC>" 'helm-for-files
  "]" 'helm-etags-select-android-art
  "a" 'xueliang-ag-search-in-project
  "b" 'helm-for-files
  "e" 'xueliang-eshell
  "E" 'xueliang-eshell-current-line
  "f" 'fiplr-find-file
  "g" 'magit-status
  "i" 'helm-semantic-or-imenu
  "I" 'helm-imenu-in-all-buffers
  "r" 'helm-recentf
  "s" 'helm-multi-swoop-all
  "S" 'xueliang-eshell-new  ;; S means 'Shell'
  "u" 'universal-argument
  "x" 'helm-M-x  ;; for easier use in the dark
)

(setq evil-mode-line-format 'before)

;; use helm-swoop instead of vim style */# find.
(define-key evil-normal-state-map (kbd "*") 'xueliang-helm-swoop-at-point)
(define-key evil-normal-state-map (kbd "#") 'xueliang-helm-swoop-at-point)
(define-key evil-normal-state-map (kbd "/") 'xueliang-helm-swoop-without-pre-input)

;; use company use C-n completion.
(define-key evil-insert-state-map (kbd "C-n") 'company-manual-begin)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============helm-config=============())
(require 'helm)
(require 'helm-config)
(require 'helm-swoop)
(require 'helm-chrome)

(setq helm-split-window-in-side-p t) ; open helm buffer inside current window
(setq helm-echo-input-in-header-line t)
(setq helm-mode-fuzzy-match nil)
(setq helm-ff-file-name-history-use-recentf nil)

(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
        helm-source-recentf
        helm-source-bookmarks
        helm-source-file-cache
        helm-source-files-in-current-dir))

;; fuzzy matching settings in helm
(setq helm-M-x-fuzzy-match        nil
      helm-buffers-fuzzy-matching t
      helm-semantic-fuzzy-match   t
      helm-swoop-use-fuzzy-match  nil
      helm-imenu-fuzzy-match      t)

;; rebind tab to the next/previous line in helm window, same behavior as company.
(define-key helm-map (kbd "TAB")       'helm-next-line)
(define-key helm-map (kbd "<tab>")     'helm-next-line)
(define-key helm-map (kbd "<backtab>") 'helm-previous-line)  ;; Shift-Tab is <backtab>
(define-key helm-map (kbd "M-x") 'helm-select-action) ;; list actions using M-x inside helm.

;; use the helm-swoop style preview.
;; because helm-execute-persistent-action kills processes in helm-top, that's why it is bound to Ctrl-Up/Down.
(define-key helm-map (kbd "C-<up>")   '(lambda() (interactive) (helm-previous-line) (helm-execute-persistent-action)))
(define-key helm-map (kbd "C-<down>") '(lambda() (interactive) (helm-next-line) (helm-execute-persistent-action)))

(setq helm-autoresize-max-height 40)
(setq helm-autoresize-min-height 15)
(helm-autoresize-mode 1)

;; if this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; helm-swoop split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color t)

(helm-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============ivy-config=============())
(require 'ivy)

;; helm for M-x, ivy for several scenarios where helm cannot complete.
(ivy-mode 1)

;; TAB behaves as ivy-partial-or-next-line
(define-key ivy-mode-map (kbd "TAB") '(lambda() (interactive) (ivy-partial) (ivy-next-line)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Company config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============company-config=============())

(add-hook 'after-init-hook 'global-company-mode)
(setq company-minimum-prefix-length 2)

; tab to select in company.
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB")   'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)))

;; instead of any key bindings for company-complete.
(add-hook 'prog-mode-hook '(lambda () (setq company-idle-delay 0)))
(add-hook 'org-mode-hook '(lambda () (setq company-idle-delay 0)))

;; not to downcase the returned candidates, keep them as-is.
(setq company-dabbrev-downcase nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Smart mode-line config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============smart-mode-line-config=============())

;; smart mode line
(require 'smart-mode-line)
(setq sml/no-confirm-load-theme t)
(smart-mode-line-enable)
(add-to-list 'sml/replacer-regexp-list '("^~/workspace/dotfiles/" ":dotfiles:") t)

(add-to-list 'sml/replacer-regexp-list '("^~/workspace/aosp/" ":aosp:") t)
(add-to-list 'sml/replacer-regexp-list '("^~/workspace/linaro/" ":linaro:") t)
(add-to-list 'sml/replacer-regexp-list '("^~/workspace/Linaro_Android_Master/" ":linaro:") t)
(add-to-list 'sml/replacer-regexp-list '("^~/workspace/" ":workspace:") t)

(add-to-list 'sml/replacer-regexp-list '("^/data/workspace/aosp/" ":aosp:") t)
(add-to-list 'sml/replacer-regexp-list '("^/data/workspace/linaro/" ":linaro:") t)
(add-to-list 'sml/replacer-regexp-list '("^/data/workspace/Linaro_Android_Master/" ":linaro:") t)
(add-to-list 'sml/replacer-regexp-list '("^/data/workspace/" ":workspace:") t)

(add-to-list 'sml/replacer-regexp-list '("^/data/workspace/aosp/external/vixl" ":aosp-vixl:") t)
(add-to-list 'sml/replacer-regexp-list '("^/data/workspace/linaro/external/vixl/" ":linaro-vixl:") t)
(add-to-list 'sml/replacer-regexp-list '("^/data/workspace/Linaro_Android_Master/external/vixl/" ":linaro-vixl:") t)
(add-to-list 'sml/replacer-regexp-list '("^~/workspace/aosp/external/vixl" ":aosp-vixl:") t)
(add-to-list 'sml/replacer-regexp-list '("^~/workspace/linaro/external/vixl/" ":linaro-vixl:") t)
(add-to-list 'sml/replacer-regexp-list '("^~/workspace/Linaro_Android_Master/external/vixl/" ":linaro-vixl:") t)

;; show which function on mode-line.
(which-function-mode 1)

;; always show which git branch I'm in.
(add-hook 'prog-mode-hook '(lambda () (vc-mode-line (buffer-file-name))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eshell config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============eshell-config=============())
;; https://www.masteringemacs.org/article/complete-guide-mastering-eshell

;; avoid company-complete being annoying in eshell mode.
(add-hook 'eshell-mode-hook '(lambda () (setq-local company-idle-delay 5)))

;; bash reverse-i-search style history search, even more powerful with helm.
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-normal-state-local-map (kbd "C-r") 'helm-eshell-history)))
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-insert-state-local-map (kbd "C-r") 'helm-eshell-history)))

;; begin-of-line, end-of-line in eshell.
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-insert-state-local-map (kbd "C-a") 'eshell-bol)))
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-normal-state-local-map (kbd "C-a") 'eshell-bol)))

(add-hook 'eshell-mode-hook '(lambda () (define-key evil-insert-state-local-map (kbd "C-e") 'evil-append-line)))
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-normal-state-local-map (kbd "C-e") 'evil-append-line)))

;; TAB to complete command in eshell, currently I'm using helm style.
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-insert-state-local-map (kbd "TAB")   'helm-esh-pcomplete)))
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-insert-state-local-map (kbd "<tab>") 'helm-esh-pcomplete)))

;; Eshell will run a term session to support following complex commands
(add-hook 'eshell-mode-hook '(lambda () (add-to-list 'eshell-visual-commands "htop")))

;; Typing clear in eshell will then result in clearing the buffer.
(defun eshell/clear ()
  "Clear the eshell buffer."
  (dotimes (i 5) (eshell-send-input)))

(defun eshell/e (arg)
  "create or edit file in another window."
  (find-file-other-window arg))

(defun eshell/ec ()
  "create emacsclient frame from eshell."
  (setq default-frame-alist '((font . "DejaVu Sans Mono")))  ;; make fonts pretty in emacsclient
  (async-shell-command "emacsclient -c"))

;; Ctrl-d just simply closes the eshell window.
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-insert-state-local-map (kbd "C-d") 'delete-window)))
(add-hook 'eshell-mode-hook '(lambda () (define-key evil-normal-state-local-map (kbd "C-d") 'delete-window)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============misc-modes-config=============())
; default theme good themes: tango-dark, zenburn, monokai, wombat
(if window-system
  (load-theme 'tango-dark t)
  (load-theme 'wombat t))

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(when window-system
  (require 'git-gutter-fringe+)
  (global-git-gutter+-mode))

(require 'guide-key)
(setq guide-key/guide-key-sequence (list xueliang-leader-key "C-h" "C-x" "C-x c"))
(setq guide-key/idle-delay 1.0)
(setq guide-key/popup-window-position 'bottom)
(guide-key-mode 1)  ; Enable guide-key-mode

;(require 'neotree)
(setq neo-smart-open 1)
(evil-define-key 'normal neotree-mode-map (kbd "TAB") '(lambda () (interactive) (neotree-enter) (neotree-hide)))
(evil-define-key 'normal neotree-mode-map (kbd "RET") '(lambda () (interactive) (neotree-enter) (neotree-hide)))
(evil-define-key 'normal neotree-mode-map (kbd "q")   'neotree-hide)

; said to make emacs faster
(remove-hook 'find-file-hooks 'vc-find-file-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; xueliang global settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============global-settings=============())

;; start server for emacsclient
(require 'server)
(unless (server-running-p)
  (server-start))

;; make things faster?
(setq echo-keystrokes 0.1)
(setq redisplay-dont-pause t)  ;; improve display performance

;; hide welcome screen
(setq inhibit-splash-screen t)

;; requires build emacs with: ./configure --with-x-toolkit=gtk
(set-default-font "DejaVu Sans Mono")

;; font size
(set-face-attribute 'default nil :height 130)

; line/column related
(column-number-mode)

;; high-light line for programming and org.
(require 'hl-line+)
(add-hook 'prog-mode-hook '(lambda () (hl-line-mode 1)))
(add-hook 'org-mode-hook  '(lambda () (hl-line-mode -1)))  ;; don't enable hl-line in org-mode.
(set-face-background hl-line-face "gray25")

;; nlinum/nlinum-relative for programming and org.
;; cost lots of CPU. And nlinum-relative-mode is even more CPU consuming.
(require 'nlinum)
(add-hook 'prog-mode-hook '(lambda () (nlinum-mode 1)))
(add-hook 'org-mode-hook  '(lambda () (nlinum-mode 1)))

;; tabs
(setq-default tab-width 2)
;; make sure '=' don't insert tab in evil-mode.
(add-hook 'prog-mode-hook '(lambda () (setq indent-tabs-mode nil)))
;; tab in insert mode is simply interpreted as inserting two spaces.
(add-hook 'prog-mode-hook
          '(lambda () (define-key evil-insert-state-local-map (kbd "TAB") '(lambda () (interactive) (insert "  ")))))

; disable some bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

; show match parentheses
(show-paren-mode)

; wrap long lines
(set-default 'truncate-lines t)

; bold font
(set-face-bold 'bold t)

; mouse
(xterm-mouse-mode 1)

; scroll
(setq scroll-step 1)

; backup files
(setq make-backup-files nil)
(setq backup-directory-alist `(("." . "~/.saves")))

; yes and no
(defalias 'yes-or-no-p 'y-or-n-p)

(require 'whitespace)
(global-whitespace-mode +1)
(setq whitespace-line-column 100) ;; limit line length
(setq whitespace-style '(face trailing lines-tail tabs))
(add-hook 'prog-mode-hook 'whitespace-mode)

; '_' as part of word
(add-hook 'c-mode-hook    '(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'c++-mode-hook  '(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'java-mode-hook '(lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'prog-mode-hook '(lambda () (modify-syntax-entry ?_ "w")))

;; modern style 'paste' in evil insert mode.
(define-key evil-insert-state-map (kbd "C-v") 'yank)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; xueliang's vars
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============vars=============())

(setq android-root "~/workspace/aosp/")
(setq android-art  (concat android-root "/art/"))
(setq android-vixl (concat android-root "/external/vixl/src/"))
(setq android-art-tags  (concat android-art  "TAGS"))
(setq android-vixl-tags (concat android-vixl "TAGS"))
(setq tags-table-list (list android-art-tags android-vixl-tags))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; xueliang's functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun =============xueliang-functions=============())

; Help to make upate TAGS of the project I'm working on easier.
(defun xueliang-update-tags-art ()
  "update etags/TAGS of Android ART project" (interactive)
  (cd android-art) (shell-command "ctag"))

(defun xueliang-update-tags-vixl ()
  "update etags/TAGS of Android VIXL project" (interactive)
  (cd android-vixl) (shell-command "ctag"))

; Help to make code reviews easier; requires cpplint.py in $PATH.
(defun xueliang-art-cpplint ()
  "invokes AOSP/art/tools/cpplint.py on current buffer" (interactive)
  (setq-local cpplint-cmd-and-options "cpplint.py --filter=-whitespace/line_length,-build/include ")
  (shell-command (concat cpplint-cmd-and-options (buffer-file-name)))
  (switch-to-buffer-other-window "*Shell Command Output*")
  (evil-window-move-very-bottom) (compilation-mode))

; Help to make cross-project search easier.
(defun xueliang-ag-vixl (arg)
  "look for WORD in VIXL using ag searcher" (interactive "P")
  (cd android-vixl) (helm-do-grep-ag arg))

; Help to make cross-project search easier.
(defun xueliang-ag-art (arg)
  "look for WORD in Android ART using ag searcher" (interactive "P")
  (cd android-art) (helm-do-grep-ag arg))

; Helper to cd to directory of current buffer/file.
(defun xueliang-cd-current-buffer-directory ()
  "cd to directory of current buffer/file." (interactive)
  (cd (file-name-directory buffer-file-name))
  (message "pwd: %s" (file-name-directory buffer-file-name)))

; for switching between .h/.cc files.
; USE NEOTREE INSTEAD
(defun xueliang-A-h-cc-files-switcher ()
  "USE NEOTREE INSTEAD; similiar to A plugin for VIM, just type 'M-x A' in helm" (interactive)
  (neotree-toggle))

; for tag search in android-art project.
(defun helm-etags-select-android-art() (interactive)
   (cd android-art) (helm-etags-select t))

; invoke e-shell
(defun xueliang-create-eshell-or-switch-to-existing ()
   (when (buffer-file-name)
     (xueliang-cd-current-buffer-directory)
     (if (get-buffer-window "*eshell*")
       (switch-to-buffer-other-window "*eshell*")
       ;; else
       (split-window-below) (evil-window-move-very-bottom) (eshell)))
   (evil-goto-line) (evil-append-line 1))

(defun xueliang-eshell-current-line ()
   "invokes eshell in a split window, send current line to eshell." (interactive)
   (setq my-cmd-in-eshell (thing-at-point 'line))
   (xueliang-create-eshell-or-switch-to-existing)
   (insert my-cmd-in-eshell) (left-char))

(defun xueliang-eshell ()
   "invokes eshell in a split window." (interactive)
   (xueliang-create-eshell-or-switch-to-existing))

(setq-default eshell-buffer-number 0)
(defun xueliang-eshell-new ()
   "invokes a new eshell in a split window, shell starts in the root of current project." (interactive)
   (setq eshell-buffer-number (+ eshell-buffer-number 1))
	 (xueliang-cd-current-buffer-directory)
   (require 'fiplr)
	 (cd (fiplr-root))  ;; since fiplr-root is a private function of fiplr, just use <leader>-f to load fiplr into emacs.
   (split-window-below) (evil-window-move-very-bottom) (eshell eshell-buffer-number)
   (evil-goto-line) (evil-append-line 1))

; search in project using ag
(defun xueliang-ag-search-in-project(argument)
  "search in project using ag; use fiplr to goto the root dir of the project"
  (interactive "P")
  (require 'fiplr)
  (cd (fiplr-root)) (helm-do-grep-ag argument))

(defun xueliang-run-linaro-art-test()
  "shows command for linaro target test single test, which can be further sent to shell to execute."
  (interactive)
  (split-window-horizontally)
  (find-file "~/workspace/dotfiles/linaro-build-scripts")
  (xueliang-helm-swoop-at-point))

;; nice helm-swoop
(defun xueliang-helm-split-window-swoop (use-pre-input)
  (setq new-helm-swoop-window nil)
  (when (window-full-width-p (get-buffer-window (buffer-name)))
    (setq new-helm-swoop-window (split-window-horizontally)))
  (if use-pre-input (helm-swoop) (helm-swoop-without-pre-input))
  (when new-helm-swoop-window
    (delete-window new-helm-swoop-window)))

(defun xueliang-helm-swoop-at-point ()
  "show helm-swoop results in a side window."
  (interactive)
  (xueliang-helm-split-window-swoop t))

(defun xueliang-helm-swoop-without-pre-input ()
  "show helm-swoop results in a side window."
  (interactive)
  (xueliang-helm-split-window-swoop nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; xueliang's key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun =============xueliang-key-bindings=============())

; Nice M-x
(global-set-key (kbd "M-x") 'helm-M-x)

; vim way of page up, the original universal argument is <leader>-u.
(global-set-key (kbd "C-u") 'evil-scroll-page-up)

;; my vim way of moving screen
(global-set-key (kbd "C-j") 'evil-scroll-line-down)
(global-set-key (kbd "C-k") 'evil-scroll-line-up)

; Better than (describe-function) and (describe-variable)
(global-set-key (kbd "C-h f") 'helm-apropos)
(global-set-key (kbd "C-h v") 'helm-apropos)

; describe key-bindings
(require 'helm-descbinds)
(global-set-key (kbd "C-h b") 'helm-descbinds)

; good way to learn all completion functions.
(global-set-key (kbd "M-/") 'hippie-expand)

; <f1> .. <f4> :
; <f5> .. <f8> : with in buffer : coding, development, tags,
; <f9> .. <f12>: with in project: buffer, find in project, related.

(global-set-key (kbd "<f5>")  'xueliang-helm-swoop-at-point) ; find in current buffer using helm-swoop.
(global-set-key (kbd "<f6>")  'helm-semantic-or-imenu)        ; imenu in current file.
(global-set-key (kbd "<f8>")  'helm-etags-select-android-art) ; find tag and jump to tag in android-art.

(global-set-key (kbd "<f9>")  'neotree-toggle)        ; neotree
(global-set-key (kbd "<f10>") 'helm-for-files)        ; find files in project.
(global-set-key (kbd "<f11>") 'helm-grep-do-git-grep) ; increment grep using git-grep.
(global-set-key (kbd "<f12>") 'helm-do-grep-ag)       ; grep current word in project.

; simply save current file
(defun xueliang-ctrl-s() "simply save current file like other modern editors do." (interactive)
       (write-file (buffer-file-name))
       (evil-force-normal-state))
(global-set-key (kbd "C-s") 'xueliang-ctrl-s)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; xueliang good tips
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; * package install RET command-log-mode, toggle-command-log/buffer
;; * M-x ansi-term
;; * Use compilation mode to parse command line outputs, e.g. cpplint's output.
;; * helm-show-kill-ring
;; * evil mode, helm, org mode, company mode.
;; * M-n/p is usually going through history items.
;; * Useful functions for coding: beginning-of-defun (C-M-home), end-of-defun (C-M-end).
;; * compilation-minor-mode in eshell, after use eshell for compiling project.
;; * helm-google-suggest is really awesome.
;; * in eshell: ls > /dev/clip can send output to clipboard for future use.

;; https://github.com/emacs-tw/awesome-emacs
;; http://www.john2x.com/emacs.html
;; https://github.com/caiorss/Emacs-Elisp-Programming
;; https://github.com/emacs-helm/helm/wiki
;; http://cestlaz.github.io/stories/emacs/
;; https://tuhdo.github.io/helm-intro.html
;; https://github.com/jwiegley/use-package
;; https://github.com/kai2nenobu/guide-key
;; http://aaronbedra.com/emacs.d/#sec-1
;; https://github.com/noctuid/evil-guide/blob/master/README.org
;; https://github.com/emacs-helm/helm/blob/master/helm-config.el
;; http://www.howardism.org/Technical/Emacs/eshell-fun.html
