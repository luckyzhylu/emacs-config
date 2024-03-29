;;; semantic-symref-idutils.el --- Symref implementation for idutils
;;
;; Copyright (C) 2009 Eric M. Ludlam
;;
;; Author: Eric M. Ludlam <eric@siege-engine.com>
;; X-RCS: $Id: semantic-symref-idutils.el,v 1.1.1.1 2012/12/16 05:21:26 zyl Exp $
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Support IDUtils use in the Semantic Symref tool.

(require 'cedet-idutils)
(require 'semantic-symref)

;;; Code:
;;;###autoload
(defclass semantic-symref-tool-idutils (semantic-symref-tool-baseclass)
  (
   )
  "A symref tool implementation using ID Utils.
The udutils command set can be used to generate lists of tags in a way
similar to that of `grep'.  This tool will parse the output to generate
the hit list.

See the function `cedet-idutils-search' for more details.")

(defmethod semantic-symref-perform-search ((tool semantic-symref-tool-idutils))
  "Perform a search with IDUtils."
  (let ((b (cedet-idutils-search (oref tool :searchfor)
				 (oref tool :searchtype)
				 (oref tool :resulttype)
				 (oref tool :searchscope)
				 ))
	)
    (semantic-symref-parse-tool-output tool b)
    ))

(defmethod semantic-symref-parse-tool-output-one-line ((tool semantic-symref-tool-idutils))
  "Parse one line of grep output, and return it as a match list.
Moves cursor to end of the match."
  (cond ((eq (oref tool :resulttype) 'file)
	 ;; Search for files
	 (when (re-search-forward "^\\([^\n]+\\)$" nil t)
	   (match-string 1)))
	((eq (oref tool :searchtype) 'tagcompletions)
	 (when (re-search-forward "^\\([^ ]+\\) " nil t)
	   (match-string 1)))
	(t
	 (when (re-search-forward "^\\([^ :]+\\):+\\([0-9]+\\):" nil t)
	   (cons (string-to-number (match-string 2))
		 (expand-file-name (match-string 1) default-directory))
	   ))))

(provide 'semantic-symref-idutils)
;;; semantic-symref-idutils.el ends here
