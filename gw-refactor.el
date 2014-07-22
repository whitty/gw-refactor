;;; my-library.el --- description of my library
;;
;; Copyright
;;
;; Author:
;; Homepage:
;; URL:
;; Version:
;; Last-Updated:
;; EmacsWiki:
;; Keywords:
;;
;; License
;;
;;; Commentary:
;;
;;; License
;;
;;; Code:
;;

;;;
;;; this is a stub to go with a .travis.yml example
;;;

(require 'cc-mode)
(require 'thingatpt)

(defun brace-pop()
  "Remove a brace and unindent."
  (interactive)
  (let ((start (point))
        (end nil))
    (save-excursion
      (forward-sexp)
      (setq end (point))
      (delete-char -1)
      )
    (delete-char 1)
    (indent-rigidly start end (- 0 c-basic-offset))
    ;; try to clean remaining whitepsace
    (let ((pos (line-end-position)))
      (beginning-of-line)
      (if (re-search-forward " +$" (line-end-position) t)
          (delete-region (match-beginning 0) (match-end 0))
        )
      )
    )
  )

;; (defun dump-things ()
;;   "debugging aid"
;;   (message "c=%s" (thing-at-point 'char))
;;   (message "sexp=%s" (thing-at-point 'sexp))
;;   (message "w=%s" (thing-at-point 'word))
;;   (message "sym=%s" (thing-at-point 'symbol))
;;   (message "syn=%s" (thing-at-point 'syntax))
;;   (message "list=%s" (thing-at-point 'list))
;;   (message "ws=%s" (thing-at-point 'white-space))
;; )

(defun if-switch()
  "Switch if/else statements.

Cursor must be on the 'if', and must use braces around both
branches.

Probably won't work with 'else if'
  "
  (interactive)
  (if (or (not (string-equal "if" (thing-at-point 'word)))
          (not (or (string-equal "i" (thing-at-point 'char))
                   (string-equal "f" (thing-at-point 'char)))))
      (error "Cursor not on 'if'"))

  ;; TODO add a "!" to the if
  ;;    (save-excursion
  ;;      (forward-sexp)
  ;;      )
  (save-excursion
    (forward-sexp)                      ; the if
    (forward-sexp)                      ; the (condition)

    ;; skip ahead to check for 'else'
    (save-excursion
      (forward-sexp)                    ; skip if-clause
      (forward-symbol 1)
      (if (not (string-equal "else" (thing-at-point 'symbol)))
          (error "No else clause"))
      )

    ;; back on the if clause
    (kill-sexp)                         ; kill the if-clause
    (forward-sexp)
    (yank)                              ; drop the if-clause
    (kill-sexp)                         ; kill the else-clause
    )
  ;; back at the start
  (forward-sexp)
  (forward-sexp)
  (yank)
  )

(provide 'gw-refactor)

;;
;; Emacs
;;
;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; byte-compile-warnings: (not cl-functions)
;; End:
;;

;;; my-library.el ends here
