
;; .emacs

(add-to-list 'load-path "~/.emacs.d/")
(load "init-basic" 'noerror)
;;(load "init-site" 'noerror)
(load "init-misc" 'noerror)
;;(load "init-toolbar" 'noerror)

;;(tool-bar-mode 0)
;(menu-bar-mode 0)
;;(scroll-bar-mode 0)

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
;; (setq frame-title-format
      ;; (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")
(setq defaut-buffer-file-coding-system 'ISO-8859)
(prefer-coding-system 'chinese-big5)
;; always end a file with a newline
;(setq require-final-newline 'query)

(setq default-directory "~/6011/ENG_SRC/update")
