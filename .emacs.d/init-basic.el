;;; -*- mode: emacs-lisp; mode: goto-address; coding: utf-8; -*-
;; Copyright (C) 2008-2011 Meteor Liu
;;
;; This code has been released into the Public Domain.
;; You may do whatever you like with it.
;;
;; @file
;; @author Meteor Liu <meteor1113@gmail.com>
;; @date 2009-08-08
;; @URL http://github.com/meteor1113/dotemacs


;;; global setting

;; user information
(setq user-full-name "zhang yunlu")
(setq user-mail-address "zhang_yunlu@venus.com")

;; path
;; (when (eq system-type 'windows-nt)
;;   (let* ((dir (file-name-directory (directory-file-name data-directory)))
;;          (bin-dir (expand-file-name "bin" dir)))
;;     (setenv "PATH" (concat bin-dir ";" (getenv "PATH"))))) ; for "| grep"
(let* ((dir (file-name-directory (or load-file-name (buffer-file-name))))
       (bin-dir (expand-file-name "bin" dir)))
  (setenv "PATH" (concat bin-dir
                         (if (eq system-type 'windows-nt) ";" ":")
                         (getenv "PATH")))
  ;; (setq exec-path (append exec-path (list bin-dir)))
  (add-to-list 'exec-path bin-dir))
(let ((cedet-possible-dirs '("~/.emacs.d/cedet-1.0pre6"
                             "~/.emacs.d/cedet-1.0pre7"
                             "~/.emacs.d/cedet-1.0"
			     "~/.emacs_config/cedet-1.1"
                             "~/.emacs.d/cedet-1.1")))
  (dolist (dir cedet-possible-dirs)
    (let ((default-directory (expand-file-name dir)))
      (when (file-exists-p default-directory)
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

 (add-to-list 'load-path     "~/.emacs.d/cedet-1.1/common")

;; c/c++ include dir (ffap use mingw dirs)
(defvar user-include-dirs
  '("." "./include" "./inc" "./common" "./public"
    ".." "../include" "../inc" "../common" "../public"
    "../.." "../../include" "../../inc" "../../common" "../../public"
    ;; "C:/MinGW/include"
    ;; "C:/MinGW/include/c++/3.4.5"
    ;; "C:/MinGW/include/c++/3.4.5/mingw32"
    ;; "C:/MinGW/include/c++/3.4.5/backward"
    ;; "C:/MinGW/lib/gcc/mingw32/3.4.5/include"
    ;; "C:/Program Files/Microsoft Visual Studio/VC98/Include"
    ;; "C:/Program Files/Microsoft Visual Studio/VC98/MFC/Include"
    ;; "C:/Program Files/Microsoft Visual Studio 10.0/VC/include"
    )
  "User include dirs for c/c++ mode")
(defvar c-preprocessor-symbol-files
  '("C:/MinGW/include/c++/3.4.5/mingw32/bits/c++config.h"
    ;; "C:/Program Files/Microsoft Visual Studio/VC98/Include/xstddef"
    ;; "C:/Program Files/Microsoft Visual Studio 10.0/VC/include/yvals.h"
    ;; "C:/Program Files/Microsoft Visual Studio 10.0/VC/include/crtdefs.h"
    )
  "Preprocessor symbol files for cedet")

;; ui
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode t))
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode 'right))
(setq scroll-step 1)
;; (setq scroll-margin 3)
;; (setq scroll-conservatively 10000)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(column-number-mode t)
(size-indication-mode 1)
;; (setq display-time-24hr-format t)
;; (setq display-time-day-and-date t)
;; (display-time-mode t)
(which-function-mode t)
(setq buffers-menu-max-size 30)
;; (setq linum-eager nil)
;; (when (fboundp 'global-linum-mode)
;;   (global-linum-mode 1))
;; (setq-default cursor-type 'bar)
;; (blink-cursor-mode -1)
(setq x-stretch-cursor t)
(xterm-mouse-mode 1)               ; (if window-system -1 1)
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame
              (xterm-mouse-mode 1))))
;; (mouse-avoidance-mode 'animate)
;; (setq mouse-autoselect-window t)
(setq-default indicate-buffer-boundaries (quote left))
(when (fboundp 'winner-mode)
  (winner-mode 1))
(setq frame-title-format
      '((:eval (or buffer-file-name (buffer-name)))
        (:eval (if (buffer-modified-p) " * " " - "))
        invocation-name
        "@"
        system-name))
(when window-system (set-background-color "honeydew")) ; #f0fff0
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (when (and (framep frame)
                       (not (eq (framep frame) t)))
              (with-selected-frame frame
                ;; (when window-system
                (set-background-color "honeydew")))))
;; (unless window-system
;;   (setq frame-background-mode 'dark))
;; (set-frame-parameter (selected-frame) 'alpha (list 85 50)) ; Transparent
;; (add-to-list 'default-frame-alist (cons 'alpha (list 85 50)))

;; edit
(setq-default tab-width 8)
(setq-default comment-column 40)        ; [C-x ;] (set-comment-column)
(setq-default major-mode 'text-mode)    ; (setq default-major-mode 'text-mode)
(setq bookmark-save-flag 1)
(global-auto-revert-mode t)
;; (setq require-final-newline 'ask)
(setq mode-require-final-newline 0)
;; (add-hook 'text-mode-hook (lambda () (setq require-final-newline nil)))
(find-function-setup-keys)
(when (fboundp 'ido-mode)
  (ido-mode t)
  (ido-everywhere t)                    ; For GUI
  (setq ido-use-filename-at-point 'guess
        ido-use-url-at-point t))
(icomplete-mode t)
(show-paren-mode t)

;; (setq show-paren-style 'expression)
;; (custom-set-faces
;;  '(show-paren-match
;;    ((((class color) (background light)) (:background "azure2")))))
(global-cwarn-mode 1)
(setq compilation-auto-jump-to-first-error t)
(setq compilation-scroll-output t)
(add-hook 'write-file-hooks 'time-stamp)
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %U")
;; (global-set-key "<" 'skeleton-pair-insert-maybe)
;; (global-set-key "(" 'skeleton-pair-insert-maybe)
;; (global-set-key "[" 'skeleton-pair-insert-maybe)
;; (global-set-key "{" 'skeleton-pair-insert-maybe)
;; (setq skeleton-pair t)
;; (setq enable-recursive-minibuffers t)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;;;; input
;;(if (fboundp 'cua-mode)
;;    (progn
;;      (setq cua-rectangle-mark-key [C-M-return])
;;      (cua-mode t)
;;      (setq cua-keep-region-after-copy t))
;;  (when (fboundp 'pc-selection-mode)
;;    (setq pc-select-selection-keys-only t)
;;    (pc-selection-mode)))
;;(setq mouse-drag-copy-region nil)
;;(setq x-select-enable-clipboard t)
;;;; (setq mouse-yank-at-point t)
;;(defalias 'yes-or-no-p 'y-or-n-p)
;;
;;;; coding
;;;; (setq system-time-locale "C")
;;(when (eq system-type 'windows-nt)
;;  (let ((code (or file-name-coding-system default-file-name-coding-system)))
;;    (setq default-process-coding-system (cons code code))))
;;(setq erc-server-coding-system '(utf-8 . utf-8))
;;;; (when (daemonp)
;;;;   (add-hook 'after-make-frame-functions
;;;;             (lambda (frame)
;;;;               (with-selected-frame frame
;;;;                 (set-locale-environment (getenv "LANG"))))))
;;
;;;; session
;;(require 'saveplace)
;;(setq-default save-place t)
;;(when (fboundp 'savehist-mode)
;;  (savehist-mode t))
;;(setq recentf-menu-open-all-flag t
;;      recentf-max-saved-items 100
;;      recentf-max-menu-items 30)
;;(recentf-mode t)
;;(defadvice recentf-track-closed-file (after push-beginning activate)
;;  "Move current buffer to the beginning of the recent list after killed."
;;  (recentf-track-opened-file))
;;(defun undo-kill-buffer (arg)
;;  "Re-open the last buffer killed.  With ARG, re-open the nth buffer."
;;  (interactive "p")
;;  (let ((recently-killed-list (copy-sequence recentf-list))
;;        (buffer-files-list
;;         (delq nil (mapcar (lambda (buf)
;;                             (when (buffer-file-name buf)
;;                               (expand-file-name (buffer-file-name buf))))
;;                           (buffer-list)))))
;;    (mapc
;;     (lambda (buf-file)
;;       (setq recently-killed-list
;;             (delete buf-file recently-killed-list)))
;;     buffer-files-list)
;;    (find-file (nth (- arg 1) recently-killed-list))))
;;(and (fboundp 'desktop-save-mode)
;;     (not (daemonp))
;;     (desktop-save-mode (if window-system 1 -1)))

;; backup
(setq make-backup-files t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;; (setq backup-by-copying t)
;; (setq delete-old-versions t)
;; (setq kept-old-versions 2)
;; (setq kept-new-versions 5)
;; (setq version-control t)

;; highlight
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))
;; (setq jit-lock-defer-time 0.05)         ; Make c mode faster
(when (fboundp 'transient-mark-mode)
  (transient-mark-mode t))
;; (setq hl-line-face 'underline)          ; for highlight-symbol
;; (global-hl-line-mode 1)                 ; (if window-system 1 -1)
;; (global-highlight-changes-mode t)       ; use cedet instead
(dolist (mode '(c-mode c++-mode objc-mode java-mode jde-mode
                       perl-mode cperl-mode php-mode python-mode ruby-mode
                       lisp-mode emacs-lisp-mode xml-mode nxml-mode html-mode
                       lisp-interaction-mode sh-mode sgml-mode))
  (font-lock-add-keywords
   mode
   '(("\\<\\(FIXME\\|TODO\\|Todo\\)\\>" 1 font-lock-warning-face prepend)
     ("\\<\\(FIXME\\|TODO\\|Todo\\):" 1 font-lock-warning-face prepend))))
;; (setq-default show-trailing-whitespace t) ; use whitespace-mode instead
(setq whitespace-style '(face trailing lines-tail newline empty tab-mark))
(when window-system
  (setq whitespace-style (append whitespace-style '(tabs newline-mark))))
;; (global-whitespace-mode t)
(eval-after-load "whitespace"
  `(defun whitespace-post-command-hook ()
     "Hack whitespace, it's very slow in c++-mode."))

;; file
;; (setq ffap-require-prefix t
;;       dired-at-point-require-prefix t)
;; (ffap-bindings)                         ; Use ido to call ffap
(autoload 'dired-jump "dired-x" nil t)
(setq kmacro-call-mouse-event nil)
(global-set-key [S-mouse-3] 'ffap-at-mouse)
(global-set-key [C-S-mouse-3] 'ffap-menu)
(eval-after-load "ffap"
  '(setq ffap-c-path (append ffap-c-path user-include-dirs)))
(eval-after-load "filecache"
  '(progn (file-cache-add-directory-list load-path)
          (file-cache-add-directory-list user-include-dirs)
          (file-cache-add-directory "/usr/include")
          (file-cache-add-directory-recursively "/usr/include/c++")
          (file-cache-add-directory-recursively "/usr/local/include")))
(filesets-init)
;; (add-to-list 'filesets-data '("~/.emacs" (:file "~/.emacs")))
;; (add-to-list 'filesets-data '("~/" (:pattern "~/" "^.+\\.*[^~]$")))
(add-to-list 'filesets-data (list "~/" (list :files
                                             "~/.emacs"
                                             "~/.emacs.desktop"
                                             "~/.emacs-places"
                                             "~/.notes"
                                             "~/.recentf"
                                             "~/.profile"
                                             "~/.bash_profile"
                                             "~/.bashrc")))
(add-to-list 'filesets-data '("~/.emacs.d" (:tree "~/.emacs.d/" "^.+\\.*$")))
(add-to-list 'filesets-data
             (list "dotemacs/"
                   (list :tree (file-name-directory
                                (or load-file-name (buffer-file-name)))
                         "^.+\\.*$")))
(add-to-list 'filesets-data (list "temp" (list :files)))

;; calendar
;; (setq calendar-chinese-all-holidays-flag t)
;; (setq mark-holidays-in-calendar t)
;; (setq calendar-week-start-day 1)
;; (setq mark-diary-entries-in-calendar t)
;; (setq diary-file "~/.emacs.d/diary")
;; (add-hook 'diary-hook 'appt-make-list)
;; (setq appt-display-format 'window)
;; (setq appt-display-mode-line t)
;; (setq appt-display-diary nil)
;; (setq appt-display-duration (* 365 24 60 60))
;; (unless (daemonp)
;;   (appt-activate 1)
;;  (delete-other-windows))
;; (diary 0)

;; autoinsert
(auto-insert-mode 1)
;; (setq auto-insert t)
;; (setq auto-insert-query nil)
(setq auto-insert-directory
      (file-name-as-directory
       (expand-file-name "etc/templates"
                         (file-name-directory (or buffer-file-name
                                                  load-file-name)))))
(setq auto-insert-expansion-alist
  '(("(>>>DIR<<<)" . (file-name-directory buffer-file-name))
    ("(>>>FILE<<<)" . (file-name-nondirectory buffer-file-name))
    ("(>>>FILE_SANS<<<)" . (file-name-sans-extension
                            (file-name-nondirectory buffer-file-name)))
    ("(>>>FILE_UPCASE<<<)" . (upcase
                              (file-name-sans-extension
                               (file-name-nondirectory buffer-file-name))))
    ("(>>>FILE_UPCASE_INIT<<<)" . (upcase-initials
                                   (file-name-sans-extension
                                    (file-name-nondirectory buffer-file-name))))
    ("(>>>FILE_EXT<<<)" . (file-name-extension buffer-file-name))
    ("(>>>FILE_EXT_UPCASE<<<)" . (upcase (file-name-extension buffer-file-name)))
    ("(>>>DATE<<<)" . (format-time-string "%d %b %Y"))
    ("(>>>TIME<<<)" . (format-time-string "%T"))
    ("(>>>VC_DATE<<<)" . (let ((ret ""))
                           (set-time-zone-rule "UTC")
                           (setq ret (format-time-string "%Y/%m/%d %T"))
                           (set-time-zone-rule nil)
                           ret))
    ("(>>>YEAR<<<)" . (format-time-string "%Y"))
    ("(>>>ISO_DATE<<<)" . (format-time-string "%Y-%m-%d"))
    ("(>>>AUTHOR<<<)" . (or user-mail-address
                            (and (fboundp 'user-mail-address)
                                 (user-mail-address))
                            (concat (user-login-name) "@" (system-name))))
    ("(>>>USER_NAME<<<)" . (or (and (boundp 'user-full-name)
                                    user-full-name)
                               (user-full-name)))
    ("(>>>LOGIN_NAME<<<)" . (user-login-name))
    ("(>>>HOST_ADDR<<<)" . (or (and (boundp 'mail-host-address)
                                    (stringp mail-host-address)
                                    mail-host-address)
                               (system-name)))))
(defun auto-insert-expand ()
  (dolist (val auto-insert-expansion-alist)
    (let ((from (car val))
          (to (eval (cdr val))))
      (goto-char (point-min))
      (replace-string from to))))
(define-auto-insert "\\.\\([Hh]\\|hh\\|hpp\\)\\'"
  ["h.tpl" auto-insert-expand])
(define-auto-insert "\\.\\([Cc]\\|cc\\|cpp\\)\\'"
  ["cpp.tpl" auto-insert-expand])
(define-auto-insert "\\.java\\'"
  ["java.tpl" auto-insert-expand])
(define-auto-insert "\\.py\\'"
  ["py.tpl" auto-insert-expand])

;; misc
(setq inhibit-startup-message t)        ; for no desktop
(setq inhibit-default-init t)           ; for frame-title-format
(setq generic-define-mswindows-modes t)
(setq generic-define-unix-modes t)
(require 'generic-x nil 'noerror)
(setq ring-bell-function 'ignore)
(auto-image-file-mode t)
;; (setq message-log-max t)
;; (add-hook 'find-file-hook 'goto-address-mode)
;; (setq max-specpdl-size 4000)
;; (setq max-lisp-eval-depth 4000)
;; (setq debug-on-error t)
;; (autoload 'zone-when-idle "zone" nil t)
;; (zone-when-idle 600)
;; zone-pgm-stress will destroy the clipboard
;; (setq zone-programs (append zone-programs nil))
;; (setq zone-programs (remq 'zone-pgm-stress zone-programs))
;; (setq zone-programs (remq 'zone-pgm-stress-destress zone-programs))

(defadvice find-tag (before tags-file-name-advice activate)
  "Find TAGS file in ./ or ../ or ../../ dirs"
  (let ((list (mapcar 'expand-file-name '("./TAGS" "../TAGS" "../../TAGS"))))
    (while list
      (if (file-exists-p (car list))
          (progn
            (setq tags-file-name (car list))
            (setq list nil))
        (setq list (cdr list))))))

(defun find-dotemacs-file ()
  "Open .emacs file"
  (interactive)
  (let* ((paths '("~/.emacs" "~/.emacs.el" "~/.emacs.d/init.el" "~/_emacs"))
         (dotemacs-path))
    (dolist (path paths)
      (and (not dotemacs-path)
           (file-exists-p path)
           (setq dotemacs-path path)))
    (find-file (or dotemacs-path
                   (locate-file "site-start.el" load-path)
                   "~/.emacs"))))

(defun move-line-up (p)
  "Move current line up, copy from crazycool@smth"
  (interactive "*p")
  (let ((c (current-column)))
    (beginning-of-line)
    (kill-line 1)
    (previous-line p)
    (beginning-of-line)
    (yank)
    (previous-line 1)
    (move-to-column c)))

(defun move-line-down (p)
  "Move current line down, copy from crazycool@smth"
  (interactive "*p")
  (let ((c (current-column)))
    (beginning-of-line)
    (kill-line 1)
    (next-line p)
    (beginning-of-line)
    (yank)
    (previous-line 1)
    (move-to-column c)))

(defun format-region ()
  "Format region, if no region actived, format current buffer.
Like eclipse's Ctrl+Alt+F."
  (interactive)
  (let ((start (point-min))
        (end (point-max)))
    (if (and (fboundp 'region-active-p) (region-active-p))
        (progn (setq start (region-beginning))
               (setq end (region-end)))
      (progn (when (fboundp 'whitespace-cleanup)
               (whitespace-cleanup))
             (setq end (point-max))))
    (save-excursion
      (save-restriction
        (narrow-to-region (point-min) end)
        (push-mark (point))
        (push-mark (point-max) nil t)
        (goto-char start)
        (when (fboundp 'whitespace-cleanup)
          (whitespace-cleanup))
        (untabify start (point-max))
        (indent-region start (point-max) nil)))))

(defun cxx-file-p (file)
  (let ((file-extension (file-name-extension file)))
    (and file-extension
         (string= file (file-name-sans-versions file))
         (find file-extension
               '("h" "hpp" "hxx" "c" "cpp" "cxx")
               :test 'string=))))

(defun format-cxx-file (file)
  "Format a c/c++ file."
  (interactive "F")
  (if (cxx-file-p file)
      (let ((buffer (find-file-noselect file))) ;; open buffer
        (save-excursion
          (set-buffer buffer)
          ;; (mark-whole-buffer)
          (when (fboundp 'whitespace-cleanup)
            (whitespace-cleanup))
          (untabify (point-min) (point-max))
          (indent-region (point-min) (point-max))
          (save-buffer)
          (kill-buffer)
          (message "Formated c++ file:%s" file)))
    (message "%s isn't a c++ file" file)))

(defun format-cxx-directory (dirname)
  "Format all c/c++ file in a directory."
  (interactive "D")
  ;; (message "directory:%s" dirname)
  (let ((files (directory-files dirname t)))
    (dolist (x files)
      (if (not (string= "." (substring (file-name-nondirectory x) 0 1)))
          (if (file-directory-p x)
              (format-cxx-directory x)
            (if (and (file-regular-p x)
                     (not (file-symlink-p x))
                     (cxx-file-p x))
                (format-cxx-file x)))))))

(autoload 'grep-tag-default "grep")
(autoload 'grep-apply-setting "grep")
(defvar grep-dir-format
  (cond ((eq system-type 'aix)
         "grep -inrH '%s' . | grep -vE \"\.svn/|\.git/|\.hg/|\.bzr/|CVS/\"")
        ;; ((eq system-type 'gnu/linux)
        ;;  "grep -inrHI '%s' . | grep -vE \"\.svn/|\.git/|\.hg/|\.bzr/|CVS/\"")
;;         ((eq system-type 'windows-nt)
;;          "grep --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.hg \
;; --exclude-dir=.bzr --exclude-dir=CVS -inrHI \"%s\" .")
        (t
         "grep --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.hg \
--exclude-dir=.bzr --exclude-dir=CVS -inrHI '%s' .")))
(defun grep-current-dir (&optional prompt wd)
  "Run `grep' to find current word in current directory."
  (interactive "P")
  (let* ((word (or wd
                   (and (fboundp 'region-active-p)
                        (region-active-p)
                        (buffer-substring-no-properties (region-beginning)
                                                        (region-end)))
                   (grep-tag-default)))
         (cmd (format grep-dir-format word)))
    (grep-apply-setting 'grep-use-null-device nil)
    (if (or prompt (= (length word) 0))
        (grep (read-shell-command
               "Run grep (like this): " cmd 'grep-history))
      (if (= 0 (length word))
          (message "Word is blank.")
        (grep cmd)))))

(defun grep-todo-current-dir ()
  "Run `grep' to find 'TODO' in current directory."
  (interactive)
  (grep-current-dir nil "TODO|FIXME"))

(defun moccur-word-all-buffers (regexp)
  "Run `multi-occur' to find regexp in all buffers."
  (if (= 0 (length regexp))
      (message "Regexp is blank.")
    (let ((buffers (buffer-list)))
      (dolist (buffer buffers)
        (let ((pos (string-match " *\\*" (buffer-name buffer))))
          (when (and pos (= 0 pos))
            (setq buffers (remq buffer buffers)))))
      (multi-occur buffers regexp))))

(defun moccur-all-buffers (&optional prompt)
  "Run `multi-occur' to find current word in all buffers."
  (interactive "P")
  (let ((word (grep-tag-default)))
    (when (or prompt (= (length word) 0))
      (setq word (read-regexp "List lines matching regexp" word)))
    (moccur-word-all-buffers word)))

(defun moccur-todo-all-buffers ()
  "Run `multi-occur' to find 'TODO' in all buffers."
  (interactive)
  (moccur-word-all-buffers
   "\\<\\([Tt][Oo][Dd][Oo]\\|[Ff][Ii][Xx][Mm][Ee]\\)\\>"))

(defun switch-to-other-buffer ()
  "Switch to (other-buffer)."
  (interactive)
  (switch-to-buffer (other-buffer)))
(defadvice switch-to-other-buffer (after pulse-advice activate)
  "After switch-to-other-buffer, pulse the line the cursor lands on."
  (when (and (boundp 'pulse-command-advice-flag) pulse-command-advice-flag
             (interactive-p))
    (pulse-momentary-highlight-one-line (point))))

(defun mark-current-line ()
  "Put point at beginning of this line, mark at end."
  (interactive)
  (move-beginning-of-line 1)
  (set-mark (point))
  (move-end-of-line 1))

(defun mark-current-line-mouse (ev)
  "Mark current line with a mouse click. EV is the mouse event."
  (interactive "e")
  (mouse-set-point ev)
  (mark-current-line))

;; (defun goto-match-paren (arg)
;;   "Go to the matching parenthesis if on parenthesis, otherwise insert %.
;; vi style of % jumping to matching brace."
;;   (interactive "p")
;;   (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
;;         ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
;;         (t (self-insert-command (or arg 1)))))
(defun goto-match-paren (arg)
  "Go to the matching  if on (){}[], similar to vi style of % "
  (interactive "p")
  ;; first, check for "outside of bracket" positions expected by forward-sexp, etc.
  (cond ((looking-at "[\[\(\{]") (forward-sexp))
        ((looking-back "[\]\)\}]" 1) (backward-sexp))
        ;; now, try to succeed from inside of a bracket
        ((looking-at "[\]\)\}]") (forward-char) (backward-sexp))
        ((looking-back "[\[\(\{]" 1) (backward-char) (forward-sexp))
        (t nil)))

(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))

;; global key bindings
(global-set-key (kbd "M-SPC") 'set-mark-command)
;; zyl (define-key cua-global-keymap (kbd "M-SPC") 'cua-set-mark)
(global-set-key (kbd "<M-up>") 'move-line-up)
(global-set-key (kbd "<M-down>") 'move-line-down)
(global-set-key (kbd "<find>") 'move-beginning-of-line) ; putty
(global-set-key (kbd "<select>") 'move-end-of-line) ; putty
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-4>") 'text-scale-decrease)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-increase)
(unless (key-binding [mouse-4])
  (global-set-key [mouse-4] 'mwheel-scroll)) ; putty
(unless (key-binding [mouse-5])
  (global-set-key [mouse-5] 'mwheel-scroll)) ; putty
(global-set-key (kbd "C-=") 'align)
(global-set-key (kbd "C-S-u") 'upcase-region)
(global-set-key (kbd "C-S-l") 'downcase-region)
;; (global-set-key (kbd "C-M-;") 'comment-or-uncomment-region)
;; (global-set-key (kbd "ESC M-;") 'comment-or-uncomment-region) ; putty
(global-set-key [M-f8] 'format-region)
(global-set-key (kbd "ESC <f8>") 'format-region) ; putty
(global-set-key (kbd "C-S-f") 'format-region)
;; (global-set-key (kbd "M-P") 'previous-buffer)
;; (global-set-key (kbd "M-N") 'next-buffer)
(global-set-key [C-prior] 'previous-buffer)
(global-set-key [C-next] 'next-buffer)
(global-set-key [(control tab)] 'switch-to-other-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c q") 'auto-fill-mode)
(define-key global-map "\C-x\C-j" 'dired-jump)
;; (global-set-key [f4] 'next-error)
(global-set-key [f4] (lambda (&optional previous)
                       (interactive "P")
                       (if previous
                           (previous-error)
                         (next-error))))
(global-set-key [S-f4] 'previous-error)
(global-set-key [f16] 'previous-error)  ; S-f4
(global-set-key [C-f4] 'kill-this-buffer)
(global-set-key (kbd "ESC <f4>") 'kill-this-buffer) ; putty
(global-set-key [(control ?.)] 'repeat)
(global-set-key [f6] 'grep-current-dir)
(global-set-key [C-f6] 'moccur-all-buffers)
(global-set-key [M-f6] 'grep-todo-current-dir)
;; (lambda () (interactive) (grep-current-dir nil "TODO|FIXME")))
(global-set-key (kbd "ESC <f6>") (key-binding [M-f6]))
(global-set-key [C-M-f6] 'moccur-todo-all-buffers)
;; '(lambda ()
;;    (interactive)
;;    (moccur-word-all-buffers
;;     "\\<\\([Tt][Oo][Dd][Oo]\\|[Ff][Ii][Xx][Mm][Ee]\\)\\>")))
(global-set-key (kbd "ESC <C-f6>") (key-binding [C-M-f6]))
(global-set-key [f7] '(lambda () (interactive) (compile compile-command)))
(global-set-key [f11] 'toggle-fullscreen)
;; (global-set-key [header-line double-mouse-1] 'kill-this-buffer)
(global-set-key [header-line double-mouse-1]
                '(lambda ()
                   (interactive)
                   (let* ((i 1)
                          (name (format "new %d" i)))
                     (while (get-buffer name)
                       (setq i (1+ i))
                       (setq name (format "new %d" i)))
                     (switch-to-buffer name))))
;; (global-set-key [header-line double-mouse-1]
;;                 '(lambda () (interactive) (switch-to-buffer "new")))
(global-set-key [header-line mouse-3] 'kill-this-buffer)
(global-set-key [mouse-2] nil)
(global-set-key [left-fringe mouse-2] nil)
(global-set-key [left-margin mouse-2] nil)
(global-set-key [mouse-3] menu-bar-edit-menu)
(global-set-key (kbd "<left-margin> <mouse-2>") 'mark-current-line-mouse)
(global-set-key (kbd "C-S-t") 'undo-kill-buffer)
(global-set-key (kbd "C-c C-v") 'view-mode)
(global-set-key [(control %)] 'goto-match-paren)
(when (eq system-type 'aix)
  (global-set-key (kbd "C-d") 'backward-delete-char-untabify)
  (eval-after-load "cc-mode"
    '(progn
       (define-key c-mode-base-map "\C-d" 'c-electric-backspace)))
  (eval-after-load "comint"
    '(progn
       (define-key comint-mode-map "\C-d" 'delete-backward-char))))


;;; special mode setting

(add-to-list 'auto-mode-alist
             '("\\.\\(exe\\|vsd\\|so\\|dll\\)$" . hexl-mode))

(defvar text-imenu-generic-expression
  `((nil ,"^ \\{0,4\\}\\([一二三四五六七八九十]+[、. )]\\)+ *[^,。，]+?$" 0)
    (nil ,"^ \\{0,4\\}\\([0-9]+[、. )]\\)+ *[^,。，]+?$" 0)))
(add-hook 'text-mode-hook
          (lambda ()
            (setq imenu-generic-expression text-imenu-generic-expression)
            (imenu-add-menubar-index)))

(setq dired-dwim-target t)
;; (add-hook 'dired-mode-hook
;;           (lambda ()
;;             (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
;;             (define-key dired-mode-map (kbd "^")
;;               (lambda () (interactive) (find-alternate-file "..")))))
(defadvice dired-find-file (around dired-find-file-single-buffer activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer))
        (filename (dired-get-file-for-visit)))
    ad-do-it
    (when (and (file-directory-p filename)
               (not (eq (current-buffer) orig)))
      (kill-buffer orig))))
(defadvice dired-up-directory (around dired-up-directory-single-buffer activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer)))
    ad-do-it
    (kill-buffer orig)))

(add-hook 'change-log-mode-hook 'turn-on-auto-fill)

(setq org-log-done 'time)
(setq org-export-with-archived-trees t)
(setq org-startup-truncated 0)
(setq org-src-fontify-natively t)
(add-hook 'org-mode-hook
          (lambda ()
            (setq comment-start 0)
            (setq indent-tabs-mode 0)
            ;; (when (fboundp 'whitespace-mode)
            ;;   (whitespace-mode 1))
            ;; (auto-fill-mode t)
            (imenu-add-menubar-index)))
(eval-after-load "org"
  `(progn
     (define-key org-mode-map [(control tab)] nil)
     (define-key org-mode-map (kbd "<C-S-iso-lefttab>")
       'org-force-cycle-archived)
     (define-key org-mode-map (kbd "<C-S-tab>") 'org-force-cycle-archived)))

(when (fboundp 'nxml-mode)
  (add-to-list 'auto-mode-alist
               '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode))
  (setq nxml-bind-meta-tab-to-complete-flag t)
  (add-hook 'nxml-mode-hook
            '(lambda ()
               ;; (when (fboundp 'whitespace-mode)
               ;;   (whitespace-mode t))
               (linum-mode 1)
               (require 'sgml-mode)
               (set-syntax-table sgml-mode-syntax-table))))

(defadvice artist-coord-win-to-buf (before tabbar-mode activate compile)
  "Hack artist-mode's wrong position when tabbar-mode."
  (if tabbar-mode (setq coord (cons (car coord) (1- (cdr coord))))))

(defvar hs--overlay-keymap nil "keymap for folding overlay")
(let ((map (make-sparse-keymap)))
  (define-key map [mouse-1] 'hs-show-block)
  (setq hs--overlay-keymap map))
(setq hs-set-up-overlay
      (defun my-display-code-line-counts (ov)
        (when (eq 'code (overlay-get ov 'hs))
          (overlay-put ov 'display
                       (propertize
                        (format "...<%d lines>"
                                (count-lines (overlay-start ov)
                                             (overlay-end ov)))
                        'face 'mode-line))
          (overlay-put ov 'priority (overlay-end ov))
          (overlay-put ov 'keymap hs--overlay-keymap)
          (overlay-put ov 'pointer 'hand))))
(eval-after-load "hideshow"
  '(progn (define-key hs-minor-mode-map [(shift mouse-2)] nil)
          (define-key hs-minor-mode-map (kbd "<left-fringe> <mouse-2>")
            'hs-mouse-toggle-hiding)))
;; (global-set-key (kbd "C-?") 'hs-minor-mode)

(defun chmod+x ()
  (and (save-excursion
         (save-restriction
           (widen)
           (goto-char (point-min))
           (save-match-data
             (looking-at "^#!"))))
       (not (file-executable-p buffer-file-name))
       (shell-command (format "chmod +x '%s'" buffer-file-name))
       (kill-buffer "*Shell Command Output*")))
(when (executable-find "chmod")
  (add-hook 'after-save-hook 'chmod+x))

(defun prog-common-function ()
  (setq indent-tabs-mode 0)
  (local-set-key (kbd "<return>") 'newline-and-indent)
  (when (fboundp 'whitespace-mode)
    (whitespace-mode t))
  (linum-mode 1)
  (hs-minor-mode t)
  (ignore-errors (imenu-add-menubar-index)))

(add-hook 'c-mode-common-hook 'prog-common-function)
(defun my-c-mode-font-lock-if0 (limit)
  (save-restriction
    (widen)
    (save-excursion
      (goto-char (point-min))
      (let ((depth 0) str start start-depth)
        (while (re-search-forward "^\\s-*#\\s-*\\(if\\|else\\|endif\\)" limit 'move)
          (setq str (match-string 1))
          (if (string= str "if")
              (progn
                (setq depth (1+ depth))
                (when (and (null start) (looking-at "\\s-+0"))
                  (setq start (match-end 0)
                        start-depth depth)))
            (when (and start (= depth start-depth))
              (c-put-font-lock-face start
                                    (match-beginning 0)
                                    'font-lock-comment-face)
              (setq start 0))
            (when (string= str "endif")
              (setq depth (1- depth)))))
        (when (and start (> depth 0))
          (c-put-font-lock-face start (point) 'font-lock-comment-face)))))
  nil)
(defun my-c-mode-common-hook-if0 ()
  (font-lock-add-keywords
   nil
   '((my-c-mode-font-lock-if0 (0 font-lock-comment-face prepend))) 'add-to-end))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook-if0)

(add-to-list 'auto-mode-alist '("\\.[ch]\\'" . c++-mode))
;; (add-hook 'c-mode-hook (lambda () (c-set-style "stroustrup")))


(defun my-c-mode-hook()
 ;(c-set-style "stroustrup")
 (c-set-style "K&R")
 (setq tab-width 8)
 (setq indent-tabs-mode t)
 (setq c-basic-offset 8)
 ;关半自动换行
 (c-toggle-auto-newline -1)
 ;贪心删除
 (c-toggle-hungry-state 1)
 ;[C +]代码折叠
 ;(define-key c-mode-base-map [(control \`)] 'hs-toggle-hiding)
 ;换行自动缩进
 (define-key c-mode-base-map [(return)] 'newline-and-indent)
 ; F7:编译
 ;; (define-key c-mode-base-map [(f5)] 'compile)
 )
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (c-set-style "stroustrup")
;;             (c-toggle-auto-hungry-state 1)
;;             (c-set-offset 'innamespace 0)))

;; (add-hook 'java-mode-hook (lambda () (c-set-style "java")))

(when (boundp 'magic-mode-alist)
  (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@implementation" . objc-mode))
  (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@interface" . objc-mode))
  (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@protocol" . objc-mode)))
;; (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*#import" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
(add-hook 'objc-mode-hook (lambda () (c-set-style "stroustrup")))

(add-to-list 'auto-mode-alist '("\\.[pP][rR][cC]\\'" . sql-mode))
(add-hook 'sql-mode-hook 'prog-common-function)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (prog-common-function)
            (turn-on-eldoc-mode)))

(add-hook 'python-mode-hook 'prog-common-function)

(add-hook 'sh-mode-hook 'prog-common-function)

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)

(add-hook 'makefile-mode-hook
          (lambda ()
            (when (fboundp 'whitespace-mode)
              (whitespace-mode t))
            (linum-mode 1)
            (imenu-add-menubar-index)))

(add-hook 'autoconf-mode-hook
          (lambda ()
            (when (fboundp 'whitespace-mode)
              (whitespace-mode t))
            (linum-mode 1)))

(add-hook 'perl-mode-hook 'prog-common-function)
(add-to-list 'auto-mode-alist
             '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
(add-hook 'cperl-mode-hook
          '(lambda ()
             (prog-common-function)
             (cperl-set-style "PerlStyle")
             (setq cperl-continued-brace-offset -4)
             (abbrev-mode t)))

;; flymake
(autoload 'flymake-find-file-hook "flymake" "" t)
;; (add-hook 'find-file-hook 'flymake-find-file-hook)
(setq flymake-allowed-file-name-masks '())
(setq flymake-gui-warnings-enabled nil)
(setq flymake-log-level 0)
(setq flymake-no-changes-timeout 5.0)
(setq flymake-master-file-dirs
      '("." "./src" "../src" "../../src"
        "./source" "../source" "../../source"
        "./Source" "../Source" "../../Source"
        "./test" "../test" "../../test"
        "./Test" "../Test" "../../Test"
        "./UnitTest" "../UnitTest" "../../UnitTest"))
(defvar flymake-mode-map (make-sparse-keymap))
(define-key flymake-mode-map (kbd "C-c <f4>") 'flymake-goto-next-error)
(define-key flymake-mode-map (kbd "C-c <S-f4>") 'flymake-goto-prev-error)
(define-key flymake-mode-map (kbd "C-c <C-f4>")
  'flymake-display-err-menu-for-current-line)
(or (assoc 'flymake-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
          (cons (cons 'flymake-mode flymake-mode-map)
                minor-mode-map-alist)))
(defadvice flymake-goto-prev-error (after display activate)
  (message (get-char-property (point) 'help-echo)))
(defadvice flymake-goto-next-error (after display activate)
  (message (get-char-property (point) 'help-echo)))

(when (executable-find "texify")
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.tex\\'" flymake-simple-tex-init))
  (add-to-list 'flymake-allowed-file-name-masks
               '("[0-9]+\\.tex\\'"
                 flymake-master-tex-init flymake-master-cleanup)))

(when (executable-find "xml")
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.xml\\'" flymake-xml-init))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.html?\\'" flymake-xml-init)))

(when (executable-find "perl")
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.p[ml]\\'" flymake-perl-init)))

(when (executable-find "php")
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.php[345]?\\'" flymake-php-init)))

(when (executable-find "make")
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.idl\\'" flymake-simple-make-init))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.java\\'"
                 flymake-simple-make-java-init flymake-simple-java-cleanup))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.cs\\'" flymake-simple-make-init)))

(defun flymake-elisp-init ()
  (if (string-match "^ " (buffer-name))
      nil
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list
       (expand-file-name invocation-name invocation-directory)
       (list
        "-Q" "--batch" "--eval"
        (prin1-to-string
         (quote
          (dolist (file command-line-args-left)
            (with-temp-buffer
              (insert-file-contents file)
              (emacs-lisp-mode)
              (condition-case data
                  (scan-sexps (point-min) (point-max))
                (scan-error
                 (goto-char(nth 2 data))
                 (princ (format "%s:%s: error: Unmatched bracket or quote\n"
                                file (line-number-at-pos)))))))))
        local-file)))))
;; (add-to-list 'flymake-allowed-file-name-masks '("\\.el$" flymake-elisp-init))
;; (add-hook 'write-file-functions (lambda nil
;;                                   (when (eq major-mode 'emacs-lisp-mode)
;;                                     (check-parens))))

(defcustom flymake-shell-of-choice "sh"
  "Path of shell.")
(defcustom flymake-shell-arguments
  (list "-n")
  "Shell arguments to invoke syntax checking.")
(defun flymake-shell-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list flymake-shell-of-choice
          (append flymake-shell-arguments (list local-file)))))
(when (executable-find flymake-shell-of-choice)
  (add-to-list 'flymake-allowed-file-name-masks '("\\.sh$" flymake-shell-init)))

(when (executable-find "pyflakes")
  (defun flymake-pyflakes-init ()
    (let* ((args nil)
           (temp-file (ignore-errors (flymake-init-create-temp-buffer-copy
                                      'flymake-create-temp-inplace))))
      (if temp-file
          (let ((local-file (file-relative-name
                             temp-file
                             (file-name-directory buffer-file-name))))
            (setq args (list "pyflakes" (list local-file))))
        (flymake-report-fatal-status
         "TMPERR" (format "Can't create temp file")))
      args))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))

(defvar flymake-makefile-filenames '("Makefile" "makefile" "GNUmakefile")
  "File names for make.")
(defvar flymake-c-file-arguments
  '(("gcc" ("-I.." "-I../include" "-I../inc" "-I../common" "-I../public"
            "-I../.." "-I../../include" "-I../../inc"
            "-I../../common" "-I../../public"
            "-Wall" "-Wextra" "-pedantic" "-fsyntax-only"))
    ("clang" ("-I.." "-I../include" "-I../inc" "-I../common" "-I../public"
              "-I../.." "-I../../include" "-I../../inc"
              "-I../../common" "-I../../public"
              "-Wall" "-Wextra" "-pedantic" "-fsyntax-only"))
    ("cl" ("/I.." "/I../include" "/I../inc" "/I../common" "/I../public"
           "/I../.." "/I../../include" "/I../../inc"
           "/I../../common" "/I../../public"
           "/EHsc" "/W4" (concat "/Fo" (getenv "TEMP") "\\null.obj") "/c"))))
(defvar flymake-cxx-file-arguments
  '(("g++" ("-I.." "-I../include" "-I../inc" "-I../common" "-I../public"
            "-I../.." "-I../../include" "-I../../inc"
            "-I../../common" "-I../../public"
            "-Wall" "-Wextra" "-pedantic" "-fsyntax-only"))
    ("clang++" ("-I.." "-I../include" "-I../inc" "-I../common" "-I../public"
                "-I../.." "-I../../include" "-I../../inc"
                "-I../../common" "-I../../public"
                "-Wall" "-Wextra" "-pedantic" "-fsyntax-only"))
    ("cl" ("/I.." "/I../include" "/I../inc" "/I../common" "/I../public"
           "/I../.." "/I../../include" "/I../../inc"
           "/I../../common" "/I../../public"
           "/EHsc" "/W4" (concat "/Fo" (getenv "TEMP") "\\null.obj") "/c"))))
(defun flymake-get-compile (arguments)
  (let ((compile nil))
    (while (and (not compile) arguments)
      (let ((arg (car arguments)))
        (if (executable-find (car arg))
            (setq compile arg)
          (setq arguments (cdr arguments)))))
    compile))
(defun flymake-get-c-compile ()
  (flymake-get-compile flymake-c-file-arguments))
(defun flymake-get-cxx-compile ()
  (flymake-get-compile flymake-cxx-file-arguments))
(defun flymake-get-cc-cmdline (source base-dir)
  (let ((args nil)
        (compile (if (string= (file-name-extension source) "c")
                     (flymake-get-c-compile)
                   (flymake-get-cxx-compile))))
    (if compile
        (setq args (list (car compile)
                         (append (car (cdr compile)) (list source))))
      (flymake-report-fatal-status
       "NOMK" (format "No compile found for %s" source)))
    args))
(defun flymake-init-find-makfile-dir (source-file-name)
  "Find Makefile, store its dir in buffer data and return its dir, if found."
  (let* ((source-dir (file-name-directory source-file-name))
         (buildfile-dir nil))
    (catch 'found
      (dolist (makefile flymake-makefile-filenames)
        (let ((found-dir (flymake-find-buildfile makefile source-dir)))
          (when found-dir
            (setq buildfile-dir found-dir)
            (setq flymake-base-dir buildfile-dir)
            (throw 'found t)))))
    buildfile-dir))
(defun flymake-simple-make-cc-init-impl (create-temp-f
                                         use-relative-base-dir
                                         use-relative-source)
  "Create syntax check command line for a directly checked source file.
Use CREATE-TEMP-F for creating temp copy."
  (let* ((args nil)
         (source-file-name buffer-file-name)
         (source-dir (file-name-directory source-file-name))
         (buildfile-dir
          (and (executable-find "make")
               (flymake-init-find-makfile-dir source-file-name)))
         (temp-source-file-name
          (ignore-errors
            (flymake-init-create-temp-buffer-copy create-temp-f))))
    (if temp-source-file-name
        (setq args
              (flymake-get-syntax-check-program-args
               temp-source-file-name
               (if buildfile-dir buildfile-dir source-dir)
               use-relative-base-dir
               use-relative-source
               (if buildfile-dir
                   'flymake-get-make-cmdline
                 'flymake-get-cc-cmdline)))
      (flymake-report-fatal-status
       "TMPERR" (format "Can't create temp file for %s" source-file-name)))
    args))
(defun flymake-simple-make-cc-init ()
  (flymake-simple-make-cc-init-impl 'flymake-create-temp-inplace t t))
(defun flymake-master-make-cc-init (get-incl-dirs-f
                                    master-file-masks
                                    include-regexp)
  "Create make command line for a source file
 checked via master file compilation."
  (let* ((args nil)
         (temp-master-file-name
          (ignore-errors
            (flymake-init-create-temp-source-and-master-buffer-copy
             get-incl-dirs-f
             'flymake-create-temp-inplace
             master-file-masks
             include-regexp))))
    (if temp-master-file-name
        (let* ((source-file-name buffer-file-name)
               (source-dir (file-name-directory source-file-name))
               (buildfile-dir
                (and (executable-find "make")
                     (flymake-init-find-makfile-dir temp-master-file-name))))
          (setq args (flymake-get-syntax-check-program-args
                      temp-master-file-name
                      (if buildfile-dir buildfile-dir source-dir)
                      nil
                      nil
                      (if buildfile-dir
                          'flymake-get-make-cmdline
                        'flymake-get-cc-cmdline))))
      (flymake-report-fatal-status
       "TMPERR" (format "Can't create temp file for %s" source-file-name)))
    args))
(defun flymake-master-make-cc-header-init ()
  (flymake-master-make-cc-init
   'flymake-get-include-dirs
   '("\\.cpp\\'" "\\.c\\'")
   "[ \t]*#[ \t]*include[ \t]*\"\\([[:word:]0-9/\\_.]*%s\\)\""))
(when (or (executable-find "make")
          (flymake-get-c-compile)
          (flymake-get-cxx-compile))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.\\(?:h\\(?:pp\\)?\\)\\'"
                 flymake-master-make-cc-header-init flymake-master-cleanup))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'"
                 flymake-simple-make-cc-init)))

;; gdb
(require 'gdb-ui nil 'noerror)
(require 'gdb-mi nil 'noerror)

(defun gud-break-or-remove (&optional force-remove)
  "Set/clear breakpoin."
  (interactive "P")
  (save-excursion
    (if (or force-remove
            (eq (car (fringe-bitmaps-at-pos (point))) 'breakpoint))
        (gud-remove nil)
      (gud-break nil))))

(defun gud-enable-or-disable ()
  "Enable/disable breakpoint."
  (interactive)
  (let ((obj))
    (save-excursion
      (move-beginning-of-line nil)
      (dolist (overlay (overlays-in (point) (point)))
        (when (overlay-get overlay 'put-break)
          (setq obj (overlay-get overlay 'before-string))))
      (if  (and obj (stringp obj))
          (cond ((featurep 'gdb-ui)
                 (let* ((bptno (get-text-property 0 'gdb-bptno obj)))
                   (string-match "\\([0-9+]\\)*" bptno)
                   (gdb-enqueue-input
                    (list
                     (concat gdb-server-prefix
                             (if (get-text-property 0 'gdb-enabled obj)
                                 "disable "
                               "enable ")
                             (match-string 1 bptno) "\n")
                     'ignore))))
                ((featurep 'gdb-mi)
                 (gud-basic-call
                  (concat
                   (if (get-text-property 0 'gdb-enabled obj)
                       "-break-disable "
                     "-break-enable ")
                   (get-text-property 0 'gdb-bptno obj))))
                (t (error "No gud-ui or gui-mi?")))
        (message "May be there isn't have a breakpoint.")))))

(defun gud-kill ()
  "Kill gdb process."
  (interactive)
  (with-current-buffer gud-comint-buffer (comint-skip-input))
  ;; (set-process-query-on-exit-flag (get-buffer-process gud-comint-buffer) nil)
  ;; (kill-buffer gud-comint-buffer))
  (dolist (buffer '(gdba gdb-stack-buffer gdb-breakpoints-buffer
                         gdb-threads-buffer gdb-inferior-io
                         gdb-registers-buffer gdb-memory-buffer
                         gdb-locals-buffer gdb-assembler-buffer))
    (when (gdb-get-buffer buffer)
      (let ((proc (get-buffer-process (gdb-get-buffer buffer))))
        (when proc (set-process-query-on-exit-flag proc nil)))
      (kill-buffer (gdb-get-buffer buffer)))))

(defadvice gdb (before ecb-deactivate activate)
  "if ecb activated, deactivate it."
  (when (and (boundp 'ecb-minor-mode) ecb-minor-mode)
    (ecb-deactivate)))

;; (defun gdb-tooltip-hook ()
;;   (gud-tooltip-mode 1)
;;   (let ((process (ignore-errors (get-buffer-process (current-buffer)))))
;;     (when process
;;       (set-process-sentinel process
;;                             (lambda (proc change)
;;                               (let ((status (process-status proc)))
;;                                 (when (or (eq status 'exit)
;;                                           (eq status 'signal))
;;                                   (gud-tooltip-mode -1))))))))
;; (add-hook 'gdb-mode-hook 'gdb-tooltip-hook)
(add-hook 'gdb-mode-hook (lambda () (gud-tooltip-mode 1)))
(defadvice gud-kill-buffer-hook (after gud-tooltip-mode activate)
  "After gdb killed, disable gud-tooltip-mode."
  (gud-tooltip-mode -1))

(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)
;; (gud-tooltip-mode t)
  (define-key c-mode-base-map [f5] 'gdb)
(eval-after-load "gud"
  '(progn
     (define-key gud-minor-mode-map [f5] (lambda (&optional kill)
                                           (interactive "P")
                                           (if kill
                                               (gud-kill)
                                             (gud-go))))
     (define-key gud-minor-mode-map [S-f5] 'gud-kill)
     (define-key gud-minor-mode-map [f17] 'gud-kill) ; S-f5
     (define-key gud-minor-mode-map [f8] 'gud-print)
     (define-key gud-minor-mode-map [C-f8] 'gud-pstar)
     (define-key gud-minor-mode-map [f9] 'gud-break-or-remove)
     (define-key gud-minor-mode-map [C-f9] 'gud-enable-or-disable)
     (define-key gud-minor-mode-map [S-f9] 'gud-watch)
     (define-key gud-minor-mode-map [f10] 'gud-next)
     (define-key gud-minor-mode-map [C-f10] 'gud-until)
     (define-key gud-minor-mode-map [C-S-f10] 'gud-jump)
     (define-key gud-minor-mode-map [f11] 'gud-step)
     (define-key gud-minor-mode-map [C-f11] 'gud-finish)))

;; buildin cedet
(when (and (fboundp 'semantic-mode)
           (not (locate-library "semantic-ctxt"))) ; can't found offical cedet
  (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                    global-semanticdb-minor-mode
                                    global-semantic-idle-summary-mode
                                    global-semantic-mru-bookmark-mode))
  (semantic-mode 1)
  (global-semantic-decoration-mode 1)
  (require 'semantic/decorate/include nil 'noerror)
  (semantic-toggle-decoration-style "semantic-tag-boundary" -1)
  (global-semantic-highlight-edits-mode (if window-system 1 -1))
  (global-semantic-show-unmatched-syntax-mode 1)
  (global-semantic-show-parser-state-mode 1)
  (global-ede-mode 1)
  (when (executable-find "global")
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode)
    (setq ede-locate-setup-options '(ede-locate-global ede-locate-base)))
  ;; (setq semantic-c-obey-conditional-section-parsing-flag nil) ; ignore #if

  ;; (defun my-semantic-inhibit-func ()
  ;;   (cond
  ;;    ((member major-mode '(Info-mode))
  ;;     ;; to disable semantic, return non-nil.
  ;;     t)
  ;;    (t nil)))
  ;; (add-to-list 'semantic-inhibit-functions 'my-semantic-inhibit-func)

  (when (executable-find "gcc")
    (require 'semantic/bovine/c nil 'noerror)
    (and (eq system-type 'windows-nt)
         (semantic-gcc-setup)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        user-include-dirs)
  (dolist (file c-preprocessor-symbol-files)
    (when (file-exists-p file)
      (setq semantic-lex-c-preprocessor-symbol-file
            (append semantic-lex-c-preprocessor-symbol-file (list file)))))

  (require 'semantic/bovine/el nil 'noerror)

  (require 'semantic/analyze/refs)      ; for semantic-ia-fast-jump
  (defadvice push-mark (around semantic-mru-bookmark activate)
    "Push a mark at LOCATION with NOMSG and ACTIVATE passed to `push-mark'.
If `semantic-mru-bookmark-mode' is active, also push a tag onto
the mru bookmark stack."
    (semantic-mrub-push semantic-mru-bookmark-ring
                        (point)
                        'mark)
    ad-do-it)
  (defun semantic-ia-fast-jump-back ()
    (interactive)
    (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
        (error "Semantic Bookmark ring is currently empty"))
    (let* ((ring (oref semantic-mru-bookmark-ring ring))
           (alist (semantic-mrub-ring-to-assoc-list ring))
           (first (cdr (car alist))))
      ;; (if (semantic-equivalent-tag-p (oref first tag) (semantic-current-tag))
      ;;     (setq first (cdr (car (cdr alist)))))
      (semantic-mrub-visit first)
      (ring-remove ring 0)))
  (defun semantic-ia-fast-jump-or-back (&optional back)
    (interactive "P")
    (if back
        (semantic-ia-fast-jump-back)
      (semantic-ia-fast-jump (point))))
  (defun semantic-ia-fast-jump-mouse (ev)
    "semantic-ia-fast-jump with a mouse click. EV is the mouse event."
    (interactive "e")
    (mouse-set-point ev)
    (semantic-ia-fast-jump (point)))
  (define-key semantic-mode-map [f12] 'semantic-ia-fast-jump-or-back)
  (define-key semantic-mode-map [C-f12] 'semantic-ia-fast-jump-or-back)
  (define-key semantic-mode-map [S-f12] 'semantic-ia-fast-jump-back)
  ;; (define-key semantic-mode-map (kbd "ESC ESC <f12>")
  ;;   'semantic-ia-fast-jump-back)
  ;; (define-key semantic-mode-map [S-f12] 'pop-global-mark)
  (global-set-key [mouse-2] 'semantic-ia-fast-jump-mouse)
  ;; (define-key semantic-mode-map [mouse-2] 'semantic-ia-fast-jump-mouse)
  (define-key semantic-mode-map [S-mouse-2] 'semantic-ia-fast-jump-back)
  (define-key semantic-mode-map [double-mouse-2] 'semantic-ia-fast-jump-back)
  (define-key semantic-mode-map [M-S-f12] 'semantic-analyze-proto-impl-toggle)
  (define-key semantic-mode-map (kbd "C-c , ,") 'semantic-force-refresh)

  (autoload 'pulse-momentary-highlight-one-line "pulse" "" nil)
  (autoload 'pulse-line-hook-function "pulse" "" nil)
  (setq pulse-command-advice-flag t)    ; (if window-system 1 nil)
  (defadvice goto-line (after pulse-advice activate)
    "Cause the line that is `goto'd to pulse when the cursor gets there."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice exchange-point-and-mark (after pulse-advice activate)
    "Cause the line that is `goto'd to pulse when the cursor gets there."
    (when (and pulse-command-advice-flag (interactive-p)
               (> (abs (- (point) (mark))) 400))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice find-tag (after pulse-advice activate)
    "After going to a tag, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice tags-search (after pulse-advice activate)
    "After going to a hit, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice tags-loop-continue (after pulse-advice activate)
    "After going to a hit, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice pop-tag-mark (after pulse-advice activate)
    "After going to a hit, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice imenu-default-goto-function (after pulse-advice activate)
    "After going to a tag, pulse the line the cursor lands on."
    (when pulse-command-advice-flag
      (pulse-momentary-highlight-one-line (point))))
  (defadvice cua-exchange-point-and-mark (after pulse-advice activate)
    "Cause the line that is `goto'd to pulse when the cursor gets there."
    (when (and pulse-command-advice-flag (interactive-p)
               (> (abs (- (point) (mark))) 400))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice switch-to-buffer (after pulse-advice activate)
    "After switch-to-buffer, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice previous-buffer (after pulse-advice activate)
    "After previous-buffer, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice next-buffer (after pulse-advice activate)
    "After next-buffer, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice ido-switch-buffer (after pulse-advice activate)
    "After ido-switch-buffer, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice beginning-of-buffer (after pulse-advice activate)
    "After beginning-of-buffer, pulse the line the cursor lands on."
    (when (and pulse-command-advice-flag (interactive-p))
      (pulse-momentary-highlight-one-line (point))))
  (add-hook 'next-error-hook 'pulse-line-hook-function))

(provide 'init-basic)
