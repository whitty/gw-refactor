
;;;
;;; this is a stub to go with a .travis.yml example
;;;

(require 'gw-refactor)

;;; helpers
(defun with-buffer-value (orig body)
  "run body against buffer containing string orig"
  (with-temp-buffer
    (goto-char (point-min))
    (insert orig)
    (goto-char (point-min))
    (funcall body)
    (buffer-string)
    )
  )

(defun file-contents (file)
  "return file contents"
  (with-temp-buffer
    (insert-file-contents-literally file nil nil nil t)
    (buffer-string)))

(defun with-buffer-file (file body)
  "run body against buffer containing contents of file"
  (with-buffer-value (file-contents file) body))


;;; interactive
(ert-deftest interactive-test-01 nil
  "This test should not run on Travis"
  :tags '(:interactive)
  (should t))

;;; noninteractive
(ert-deftest if-switch-test nil
  "This test should run on Travis"
  (should (equal (with-buffer-file
                  "fixtures/if_test_01.c"
                  (lambda ()
                    ;; move to start of second if
                    (word-search-forward "if" nil nil 2)
                    (backward-word)
                    ;; run if-switch
                    (if-switch)
                    ))
                 (file-contents "fixtures/if_test_01_exp.c")))
  )


;;
;; Emacs
;;
;; Local Variables:
;; indent-tabs-mode: nil
;; coding: utf-8
;; End:
;;

;;; my-library-test.el ends here
