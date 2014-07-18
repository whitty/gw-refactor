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

(defun brace-pop()
  "Remove a brace and unindent."
  (interactive)
  (let* ((start (point))
         (end nil))
    (save-excursion
      (forward-sexp)
      (setq end (point))
      (delete-char -1)
      )
    (delete-char 1)
    (indent-rigidly start end (- 0 c-basic-offset))
    )
  )

(defun if-switch()
  "Switch if/else statements."
  (interactive)
  (save-excursion
    ;; TODO add a "!" to the if
    ;;    (save-excursion
    ;;      (forward-sexp)
    ;;      )
    (save-excursion
      (forward-sexp)
      (forward-sexp)
      (kill-sexp) ; kill the if
      (forward-sexp)
      (yank) ; drop the if
      (kill-sexp) ; kill the else
      )
    (forward-sexp)
    (forward-sexp)
    (yank)
    )
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
