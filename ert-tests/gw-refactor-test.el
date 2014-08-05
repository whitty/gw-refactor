
;;;
;;; this is a stub to go with a .travis.yml example
;;;

(require 'gw-refactor)

;;; helpers
(defun with-buffer-value (orig body &optional setup)
  "run body against buffer containing string orig"
  (with-temp-buffer
    (if setup
        (funcall setup))
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

(defun with-buffer-file (file body &optional setup)
  "run body against buffer containing contents of file"
  (with-buffer-value (file-contents file) body setup))


;;; interactive
(ert-deftest interactive-test-01 nil
  "This test should not run on Travis"
  :tags '(:interactive)
  (should t))

;;; noninteractive
(ert-deftest if-switch-is-interactive nil
  "if-switch is interactive"
  (should (interactive-form 'if-switch)))

(ert-deftest if-switch-cond-is-interactive nil
  "if-switch-cond is interactive"
  (should (interactive-form 'if-switch-cond)))

(defun basic-if-switch-test (fn file1 file2)
  (should (equal
           (with-buffer-file file1
                             (lambda ()
                               ;; move to start of second if
                               (word-search-forward "if" nil nil 2)
                               (backward-word)
                               ;; run if-switch
                               (funcall fn)
                               ))
           (file-contents file2))))

(ert-deftest if-switch-test nil
  "Basic if switches"
  (basic-if-switch-test 'if-switch
                  "fixtures/if_test_01.c" "fixtures/if_test_01_exp.c"))

(ert-deftest if-switch-test-2 nil
  "Basic if switches (hanging brace on else)"
  (basic-if-switch-test 'if-switch
                  "fixtures/if_test_02.c" "fixtures/if_test_02_exp.c"))

(ert-deftest if-switch-test-3 nil
  "Hanging multiline condition"
  (basic-if-switch-test 'if-switch
                  "fixtures/if_test_03.c" "fixtures/if_test_03_exp.c"))

(ert-deftest if-switch-cond-test nil
  "Basic if switches"
  (basic-if-switch-test 'if-switch-cond
                  "fixtures/if_test_01.c" "fixtures/if_test_01_cond_exp.c"))

(ert-deftest if-switch-cond-test-2 nil
  "Basic if switches (hanging brace on else)"
  (basic-if-switch-test 'if-switch-cond
                  "fixtures/if_test_02.c" "fixtures/if_test_02_cond_exp.c"))

(ert-deftest if-switch-cond-test-3 nil
  "Hanging multiline condition"
  (basic-if-switch-test 'if-switch-cond
                  "fixtures/if_test_03.c" "fixtures/if_test_03_cond_exp.c"))


;;;;;;;;;;;;;;;;;;;;;;;;;; negative tests
(ert-deftest if-switch-test-on-f nil
  "if-switch should work on either the `i` or the `f` of `if`"
  (should (equal (with-buffer-file
                  "fixtures/if_test_01.c"
                  (lambda ()
                    ;; move to the end of second if (ie the 'f')
                    (word-search-forward "if" nil nil 2)
                    (backward-char)
                    ;; run if-switch
                    (if-switch)
                    ))
                 (file-contents "fixtures/if_test_01_exp.c")))
)

(ert-deftest if-switch-test-not-on-if nil
  "Should error if not on `if`"
  (should (equal 
           (first (last 
                   (should-error (with-buffer-file
                                  "fixtures/if_test_01.c"
                                  (lambda ()
                                    ;; move to after the second if
                                    (word-search-forward "if" nil nil 2)
                                    ;;(backward-word)
                                    ;; run if-switch
                                    (if-switch)
                                    ))
                                 :type 'error)))
           "Cursor not on 'if'"))
  )

(ert-deftest if-switch-test-no-else-clause nil
  "This test should run on Travis"
  (should (equal 
           (first (last 
                   (should-error (with-buffer-file
                                  "fixtures/if_test_01.c"
                                  (lambda ()
                                    ;; move to the first if (no else)
                                    (word-search-forward "if" nil nil 1)
                                    (backward-word)
                                    ;; run if-switch
                                    (if-switch)
                                    ))
                                 :type 'error)))
           "No else clause"))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; brace-pop tests
(ert-deftest brace-pop-is-interactive nil
  "brace-pop is interactive"
  (should (interactive-form 'brace-pop)))

(ert-deftest brace-pop-test nil
  "Basic if switches"
  (should (equal (with-buffer-file
                  "fixtures/brace_pop_01.c"
                  (lambda ()
                    ;; move to start of second {
                    (search-forward "{" nil nil 2)
                    (backward-char)
                    ;; run brace-pop
                    (brace-pop)
                    )
                  ;; configure buffer
                  (lambda () (c-mode)
                    (setq c-basic-offset 2)))

                 (file-contents "fixtures/brace_pop_01_exp.c")))
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
