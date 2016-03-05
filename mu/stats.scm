#!/bin/sh
exec guile -e main -s $0 $@
!#
;;
;; INFO: Print new, unread and total message count for each maildir
;; INFO: Usage: stats.scm <maildir> <maildir> ...
;;

(use-modules (mu) (mu stats))
(mu:initialize)

(define (count-msgs folder)
  "Return a list of (new-count unread-count total-count) of messages in FOLDER."
  (list (mu:count (format #f "maildir:/~a flag:new" folder))
	(mu:count (format #f "maildir:/~a flag:unread" folder))
	(mu:count (format #f "maildir:/~a" folder))))

(define (print-folder-row folder)
  ;; print message counts
  (let ((counts (count-msgs folder)))
    (format #t "~15a ~10:d ~10:d ~10:d\n"
	    (format #f "~a" folder)
	    (list-ref counts 0)
	    (list-ref counts 1)
	    (list-ref counts 2))))

(define (print-each-folder-stats folders)
  (for-each print-folder-row folders))

(define (print-headers)
  (format #t "~15a ~10@a ~10@a ~10@a\n"
	  "Folder" "New" "Unread" "Total"))

(define (main args)
  (let ((folders (cdr args)))
    (print-headers)
    (print-each-folder-stats folders)))
