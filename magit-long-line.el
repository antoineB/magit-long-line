;;; magit-long-line.el --- Hide long lines inside magit diff  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  

;; Author:  <antoine@antoine-AB350-Gaming>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; For instance match all files ending in .min.js and truncate every line exceding 30 chars.
;; (setq magit-diff-wash-diffs-hook (list (lambda () (magit-long-line--truncate "\\.min\\.js$" 30 "… long line"))))


;;; Code:

;; this variable is used in magit but never defined
(when (not (boundp 'magit-diff-wash-diffs-hook))
    (defvar magit-diff-wash-diffs-hook '()))

(defun magit-long-line--truncate (regexp length text)
  "truncate long line in a magit diff buffer for files matching
`regexp' exceding `length' and replace its content with `text'"
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^--- \\(.+\\)" nil t)
      (when (string-match-p regexp (match-string 1))
        (let ((end-file-point (save-excursion
                                (if (re-search-forward "^--- " nil t)
                                    (match-beginning 0)
                                  (point-max)))))
          (re-search-forward "^@@ " end-file-point t)
          (search-forward "\n")
          (while (< (point) end-file-point)
            (when (looking-at "@@ ")
              (search-forward "\n"))
            (when (not (search-forward "\n" (+ (point) length) t))
              (goto-char (+ (point) length))
              (if (looking-at "\n")
                  (search-forward "\n")
                (kill-line)
                (insert text)
                (search-forward "\n")))))))))


(provide 'magit-long-line)
;;; magit-long-line.el ends here
