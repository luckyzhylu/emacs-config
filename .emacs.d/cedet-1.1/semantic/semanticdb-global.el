;;; semanticdb-global.el --- Semantic database extensions for GLOBAL

;;; Copyright (C) 2002, 2003, 2004, 2005, 2006, 2008, 2009, 2010, 2011 Eric M. Ludlam

;; Author: Eric M. Ludlam <zappo@gnu.org>
;; Keywords: tags
;; X-RCS: $Id: semanticdb-global.el,v 1.1.1.1 2012/12/16 05:21:26 zyl Exp $

;; This file is not part of GNU Emacs.

;; Semanticdb is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.
;;
;;; Commentary:
;;
;; Use GNU Global for by-name database searches.
;;
;; This will work as an "omniscient" database for a given project.
;;

(require 'semantic-symref-global)

(eval-when-compile
  ;; For generic function searching.
  (require 'eieio)
  (require 'eieio-opt)
  )
;;; Code:
;;;###autoload
(defun semanticdb-enable-gnu-global-databases (mode &optional noerror)
  "Enable the use of the GNU Global SemanticDB back end for all files of MODE.
This will add an instance of a GNU Global database to each buffer
in a GNU Global supported hierarchy.

Two sanity checks are performed to assure (a) that GNU global program exists
and (b) that the GNU global program version is compatibility with the database
version.  If optional NOERROR is nil, then an error may be signalled on version
mismatch.  If NOERROR is not nil, then no error will be signlled.  Instead
return value will indicate success or failure with non-nil or nil respective
values."
  (interactive
   (list (completing-read
          "Enable in Mode: " obarray
          #'(lambda (s) (get s 'mode-local-symbol-table))
          t (symbol-name major-mode))))

  ;; First, make sure the version is ok.
  (if (not (cedet-gnu-global-version-check noerror))
      nil
    ;; Make sure mode is a symbol.
    (when (stringp mode)
      (setq mode (intern mode)))

    (let ((ih (mode-local-value mode 'semantic-init-mode-hook)))
      (eval `(setq-mode-local
              ,mode semantic-init-mode-hook
              (cons 'semanticdb-enable-gnu-global-hook ih))))
    t
    )
  )

(defun semanticdb-enable-gnu-global-hook ()
  "Add support for GNU Global in the current buffer via `semantic-init-hook'."
  (semanticdb-enable-gnu-global-in-buffer t))

(defclass semanticdb-project-database-global
  ;; @todo - convert to one DB per directory.
  (semanticdb-project-database eieio-instance-tracker)

  ;; @todo - use instance tracker symbol.
  ()
  "Database representing a GNU Global tags file.")

(defun semanticdb-enable-gnu-global-in-buffer (&optional dont-err-if-not-available)
  "Enable a GNU Global database in the current buffer.
When GNU Global is not available for this directory, display a message
if optional DONT-ERR-IF-NOT-AVAILABLE is non-nil; else throw an error."
  (interactive "P")
  (if (cedet-gnu-global-root)
      (setq
       ;; Add to the system database list.
       semanticdb-project-system-databases
       (cons (semanticdb-project-database-global "global")
	     semanticdb-project-system-databases)
       ;; Apply the throttle.
       semanticdb-find-default-throttle
       (append semanticdb-find-default-throttle
	       '(omniscience))
       )
    (if dont-err-if-not-available
	nil; (message "No Global support in %s" default-directory)
      (error "No Global support in %s" default-directory))
    ))

;;; Classes:
(defclass semanticdb-table-global (semanticdb-search-results-table)
  ((major-mode :initform nil)
   )
  "A table for returning search results from GNU Global.")

(defmethod object-print ((obj semanticdb-table-global) &rest strings)
  "Pretty printer extension for `semanticdb-table-global'.
Adds the number of tags in this file to the object print name."
  (apply 'call-next-method obj (cons " (proxy)" strings)))

(defmethod semanticdb-equivalent-mode ((table semanticdb-table-global) &optional buffer)
  "Return t, pretend that this table's mode is equivalent to BUFFER.
Equivalent modes are specified by the `semantic-equivalent-major-modes'
local variable."
  ;; @todo - hack alert!
  t)

;;; Filename based methods
;;
(defmethod semanticdb-get-database-tables ((obj semanticdb-project-database-global))
  "For a global database, there are no explicit tables.
For each file hit, get the traditional semantic table from that file."
  ;; We need to return something since there is always the "master table"
  ;; The table can then answer file name type questions.
  (when (not (slot-boundp obj 'tables))
    (let ((newtable (semanticdb-table-global "GNU Global Search Table")))
      (oset obj tables (list newtable))
      (oset newtable parent-db obj)
      (oset newtable tags nil)
      ))

  (call-next-method))

(defmethod semanticdb-file-table ((obj semanticdb-project-database-global) filename)
  "From OBJ, return FILENAME's associated table object."
  ;; We pass in "don't load".  I wonder if we need to avoid that or not?
  (car (semanticdb-get-database-tables obj))
  )

;;; Search Overrides
;;
;; Only NAME based searches work with GLOBAL as that is all it tracks.
;;
(defmethod semanticdb-find-tags-by-name-method
  ((table semanticdb-table-global) name &optional tags)
  "Find all tags named NAME in TABLE.
Return a list of tags."
  (if tags
      ;; If TAGS are passed in, then we don't need to do work here.
      (call-next-method)
    ;; Call out to GNU Global for some results.
    (let* ((semantic-symref-tool 'global)
	   (result (semantic-symref-find-tags-by-name name 'project))
	   )
      (when result
	;; We could ask to keep the buffer open, but that annoys
	;; people.
	(semantic-symref-result-get-tags result))
      )))

(defmethod semanticdb-find-tags-by-name-regexp-method
  ((table semanticdb-table-global) regex &optional tags)
  "Find all tags with name matching REGEX in TABLE.
Optional argument TAGS is a list of tags to search.
Return a list of tags."
  (if tags (call-next-method)
    (let* ((semantic-symref-tool 'global)
	   (result (semantic-symref-find-tags-by-regexp regex 'project))
	   )
      (when result
	(semantic-symref-result-get-tags result))
      )))

(defmethod semanticdb-find-tags-for-completion-method
  ((table semanticdb-table-global) prefix &optional tags)
  "In TABLE, find all occurrences of tags matching PREFIX.
Optional argument TAGS is a list of tags to search.
Returns a table of all matching tags."
  (if tags (call-next-method)
    (let* ((semantic-symref-tool 'global)
	   (result (semantic-symref-find-tags-by-completion prefix 'project))
	   (faketags nil)
	   )
      (when result
	(dolist (T (oref result :hit-text))
	  ;; We should look up each tag one at a time, but I'm lazy!
	  ;; Doing this may be good enough.
	  (setq faketags (cons
			  (semantic-tag T 'function :faux t)
			  faketags))
	  )
	faketags))))

;;; Deep Searches
;;
;; If your language does not have a `deep' concept, these can be left
;; alone, otherwise replace with implementations similar to those
;; above.
;;
(defmethod semanticdb-deep-find-tags-by-name-method
  ((table semanticdb-table-global) name &optional tags)
  "Find all tags name NAME in TABLE.
Optional argument TAGS is a list of tags to search.
Like `semanticdb-find-tags-by-name-method' for global."
  (semanticdb-find-tags-by-name-method table name tags))

(defmethod semanticdb-deep-find-tags-by-name-regexp-method
  ((table semanticdb-table-global) regex &optional tags)
  "Find all tags with name matching REGEX in TABLE.
Optional argument TAGS is a list of tags to search.
Like `semanticdb-find-tags-by-name-method' for global."
  (semanticdb-find-tags-by-name-regexp-method table regex tags))

(defmethod semanticdb-deep-find-tags-for-completion-method
  ((table semanticdb-table-global) prefix &optional tags)
  "In TABLE, find all occurrences of tags matching PREFIX.
Optional argument TAGS is a list of tags to search.
Like `semanticdb-find-tags-for-completion-method' for global."
  (semanticdb-find-tags-for-completion-method table prefix tags))

;;; TEST
;;
;; Here is a testing fcn to try out searches via the GNU Global database.
(defvar semanticdb-test-gnu-global-startfile "~/src/global-5.7.3/global/global.c"
  "File to use for testing.")

(defun semanticdb-test-gnu-global (searchfor &optional standardfile)
  "Test the GNU Global semanticdb.
Argument SEARCHFOR is the text to search for.
If optional arg STANDARDFILE is non nil, use a standard file w/ global enabled."
  (interactive "sSearch For Tag: \nP")

  (save-excursion
    (when standardfile
      (save-match-data
	(set-buffer (find-file-noselect semanticdb-test-gnu-global-startfile))))

    (condition-case err
	(semanticdb-enable-gnu-global-in-buffer)
      (error (if standardfile
		 (error err)
	       (save-match-data
		 (set-buffer (find-file-noselect semanticdb-test-gnu-global-startfile)))
	       (semanticdb-enable-gnu-global-in-buffer))))

    (let* ((db (semanticdb-project-database-global "global"))
	   (tab (semanticdb-file-table db (buffer-file-name)))
	   (result (semanticdb-deep-find-tags-for-completion-method tab searchfor))
	   )
      (data-debug-new-buffer "*SemanticDB Gnu Global Result*")
      (data-debug-insert-thing result "?" "")
      )))

(provide 'semanticdb-global)

;;; semanticdb-global.el ends here
