;;; fact						
(define (fact n) 
			(cond ((= 0 n) 1) 
			(else (* n (fact 
						(- n 1))))))
;;; fibonacci
(define (fib n) 
		(cond ((<= n 2) 1) 
		(else (+ (fib (- n 1)) (fib (- n 2))))))
;;; append
(define (myapp x y) 
			(if (null? x) y 
				(cons (car x) (myapp (cdr x) y))))
;;; absolute val
(define absVal (lambda (x)
					(if (< x 0) (- x) x)))
;;; sum list numbers
(define sumList (lambda (x)
			(if (null? x) 0 (+ (car x) (sumList (cdr x))))))
;;; reference list by index
(define (my-list-ref lst n)
	(if (zero? n)
	    (car lst)
	    (my-list-ref (cdr lst) (- n 1))))
;;;mapp
(define (myMapp fn lst)
			(if (= (length lst) 1) (car lst)
			(fn (car lst) (myMapp fn (cdr lst)))))
;;;alternative.... does it work correctly????
(define (my-map fn lst)
	(if (null? lst) null
	    (cons (fn (car lst))
	        	   (my-map fn (cdr lst)))))

(define (replace lst find repl)
			(cond 
				((null? lst) 
					'())	
				((= find (car lst)) 
					(cons repl (replace (cdr lst) find repl)))
				(else 
					(cons (car lst) (replace (cdr lst) find repl)))))

(define (replace2 lst find repl)
	(if (pair? lst)
	    (cons 
		(replace2 (car lst) find repl)
		(replace2 (cdr lst) find repl))
	    (if (equal? find lst)
	        repl
	        lst)))