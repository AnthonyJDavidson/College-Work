;;; Church Encoding Assignment
;;; Anthony James Davidson 10307653 

;;; Done using Racket v5.1.3 (in terminal in Ubuntu)


;;; From the lectures  (mostly ignore, here for reference)
(define c5 (lambda (f g) (lambda (x) (f (f (f (f (f x))))))))
(define c4 (lambda (f g) (lambda (x) (f (f (f (f x)))))))
(define cN3 (lambda (f g) (lambda (x) (g (g (g x))))))

(define s-cons* (lambda (ta d) (lambda () (list ta d)))) ; takes A as "thunk"
(define s-cons (lambda (a d) (s-cons* (lambda () a) d))) ; takes A as "regular" value
(define s-car (lambda (s) ((car (s)))))	; returns "regular" value
(define s-cdr (lambda (s) (cadr (s))))	; returns stream
(define s-null? (lambda (s) (null? (s))))
(define s-null (lambda () '()))


;;; Complete tosh, ignore
		(define churRep 
			(lambda (x) 
				(if (> x -1) 
				(churPos x) 
				(churNeg x))))

		;;; If positive number 
		(define churPos 
			(lambda (x) 
				(if (= x 1) 
				'(f x)
				(s-cons 'f (churPos (- x 1))))))

		;;; If negative number
		(define churNeg 
			(lambda (x) 
				(if (= x -1) 
				'(g x)
				(s-cons 'g (churPos (- g 1))))))



;;; Assignment
;;; Part A

;;; zero c0
(define c0 (lambda (f) 
				(lambda (x) x)))

;;; add1 (successor)
(define (add1 n)
   (lambda (f) (lambda (x) (f ((n f) x)))))


;;; VERY IMPORTANT
;;; returning a dec from a church num
(define (decChur cNum)
	((cNum (lambda (a) (+ a 1))) 
        0))


;;; Creating the church numeral (positive currently)
(define churchNum (lambda (n) 
					(if (> n 0)
						(add1 (churchNum (- n 1)))
						c0)))


;;;  _____       .___  .___.__  __  .__               
;;;  /  _  \    __| _/__| _/|__|/  |_|__| ____   ____  
;;; /  /_\  \  / __ |/ __ | |  \   __\  |/  _ \ /    \ 
;;;/    |    \/ /_/ / /_/ | |  ||  | |  (  <_> )   |  \
;;;\____|__  /\____ \____ | |__||__| |__|\____/|___|  /
;;;        \/      \/    \/                         \/ 

;;; ADDITION
;;; from http://www.cs.rice.edu/~javaplt/311/Readings/supplemental.pdf
;;; = λM . λN . λf . λx . N f(M f x)
;;; = λf.λx.(N f((M f)x))

;;; currently works for positive only
(define (c-int+ N M)
  (lambda (f) 
  	(lambda (x) 
  		((N f) ((M f) x))))) ;;; English - proc (N f) on proc (M f) on x

(define three (churchNum 3))
(define four (churchNum 4))
(define seven (c-int+ three four))
(define sevenDec (decChur seven));;; type sevenDec into interpreter (= 7)


;;; Example from terminal

;;;	> (define two (churchNum 2))
;;;	> (define three (churchNum 3))
;;;	> (define five (c-int+ two three))
;;;	> (decChur five)
;;;	5
;;;	> (define eight (c-int+ five three))
;;;	> (decChur 8)
;;;	8


;;; Subtraction
;;; ???



;;; MULTIPLICATION
;;; from http://www.cs.rice.edu/~javaplt/311/Readings/supplemental.pdf

;;; CN*M = λf . λx . N(M f)x

;;; x needed?

(define (c-int* N M)
            (lambda (f)
                (N (M f))))


(define num (c-int* 
	(c-int+ (churchNum 2) (churchNum 2)) 
	(c-int+ (churchNum 1) (churchNum 1))))
(define eight (decChur num)) ;;; in terminal this will give "8"

;;; Example from terminal

;;;__________                           
;;;\______   \______  _  __ ___________ 
;;; |     ___/  _ \ \/ \/ // __ \_  __ \
;;; |    |  (  <_> )     /\  ___/|  | \/
;;; |____|   \____/ \/\_/  \___  >__|   
;;;                            \/       
;;; POWER
;;; Modified multiplication

(define c-int-expt
		(lambda (N M) 
			(M N)))

(define tsev (c-int-expt (churchNum 3) (churchNum 3)))
(define twentySeven (decChur tsev)) ;;; gives 27 in decimal = 3^3

;;; terminal example 
;;; > (define ten (c-int+ (churchNum 4) (churchNum 6)))
;;; > (define three (churchNum 3))
;;; > (define numPow (c-int-expt three ten))         
;;; > (decChur numPow)
;;; 59049




;;; PART B
;;; 1024 = (4 2 0 1)
(define nat-to-dlnat 
		(lambda (x)
			(if (> x 0)
			(append (list (modulo x 10)) 
				(nat-to-dlnat 
					(/ (- x (modulo x 10)) 10)))
			null)))


;;; (4 2 0 1) = 1024
(define dlnat-to-nat
		(lambda (x)
			(if (< 1 (length (cdr x)))
			(+ (car x) 
				(dlnat-to-nat 
					(map (lambda (l) (* 10 l)) (cdr x))))
			(+ (car x) (* 10 (cadr x))))))

;;; This function will be used to make the length of the lists 
;;; containing the dlnats of operands the same 
;;; i.e. (1 2 0) + (3 4) ==> (1 2 0) + (3 4 0) using this func as passthrough
(define addZeroes 
	(lambda (lis len)
		(if (> len 0)
			(addZeroes (append lis (list 0)) (- len 1))
			lis)))



;;; ADDITION
;;; add two dlnats
(define dl+ (lambda (d1 d2) 
 				(cond 
 				((= (length d1) (length d2)) 
 					(dlPlusMain (append d1 (list 0)) (append d2 (list 0)))) 
 				((> (length d1) (length d2)) 
 					(dlPlusMain 
 						(append d1 (list 0)) 
 						(append 
 							(addZeroes d2 (- (length d1) (length d2))) 
 							(list 0))))
 				(else (dlPlusMain 
 						(append d2 (list 0)) 
 						(append 
 							(addZeroes d1 (- (length d2) (length d1))) 
 							(list 0)))))))

;;; Main part of addition, (first part checking sizes)
;;; here dl1 is bigger that dl2 or same length 
;;; (doesnt matter which is dec value higher)
(define dlPlusMain 
		(lambda (dl1 dl2) 
			(if (< 1 (length dl1)) 
				(if (< 10 (+ (car dl1) (car dl2))) 
					(append 
						(list (- (+ (car dl1) (car dl2)) 10)) 
						(dlPlusMain 
							(append (list (+ (car dl1) 1) (cddr dl1))) 
							(cdr dl2))) 
					(append 
						(list (+ (car dl1) (car dl2))) 
						(dlPlusMain 
							(cdr dl1) 
							(cdr dl2)))) 
				(list (+ (car dl1) (car dl2))))))


;;;Multiplication
(define removeZeroes (lambda (dl)
						(if (= 0 (car dl)) 
								(removeZeroes (cdr dl)) 
								(reverse dl))))
(define dl* (lambda (d1 d2) 
				(dlMult (removeZeroes (reverse d1)) (removeZeroes (reverse d2)))))

(define dlMult 
	(lambda (dl1 dl2)
		(if (= 1 (length dl1))
			(removeCarry (map (lambda (l) (* (car dl1) l)) dl2))
			(dl+ 
				(removeCarry (map (lambda (l) (* (car dl1) l)) dl2)) 
				(append 
					(list 0) 
					(dlMult (cdr dl1) dl2))))))







;;; Comparisons
;;; equals
(define dl= (lambda (d1 d2) 
 				(cond 
 				((= (length d1) (length d2)) 
 					(dlEquals (reverse d1) (reverse d2))) 
 				((> (length d1) (length d2)) 
 					(dlEquals 
 						(reverse d1) 
 						(reverse (addZeroes d2 (- (length d1) (length d2))))))
 				(else (dlEquals 
 						(reverse d2) 
 						(reverse (addZeroes d1 (- (length d2) (length d1)))))))))

(define dlEquals (lambda (dl1 dl2) 
					(if (< 1 (length dl1))
						(if (= (car dl1) (car dl2))
							(dlEquals (cdr dl1) (cdr dl2))
							#f)
						(= (car dl1) (car dl2)))))

;;; examples from terminal
;;; > (dl= '(4 2 0 1) '(4 2 0 1))
;;; #t
;;; > (dl= '(4 2 0 1 0 0 0) '(4 2 0 1 0 0 0))
;;; #t
;;; > (dl= '(4 2 0 1 0 0 0 1) '(4 2 0 1 0 0))
;;; #f
;;; > (dl= '(3 2 1) '(4 2 1))
;;; #f
;;; > (dl= '( 1 0 0 0 0 0 0 0) '(2 0 0 0 0 0 0))
;;; #f


;;; less than
(define dl< (lambda (d1 d2) 
				(cond 
 				((= (length d1) (length d2)) 
 					(dlLess (reverse d1) (reverse d2))) 
 				((> (length d1) (length d2)) 
 					(dlLess 
 						(reverse d1) 
 						(reverse (addZeroes d2 (- (length d1) (length d2))))))
 				(else (dlLess 
 						(reverse (addZeroes d1 (- (length d2) (length d1)))) 
 						(reverse d2))))))


(define dlLess (lambda (dl1 dl2)
				(if (< 1 (length dl1))
						(cond 
							((< (car dl1) (car dl2)) 
							#t)
							((= (car dl1) (car dl2)) 
							(dlLess (cdr dl1) (cdr dl2)))
							(else #f))
						(< (car dl1) (car dl2)))))

;;; Examples from terminal 
;;; > (dl< '(4 5 6 7) '(4 5 6 7 0))
;;; #f
;;; > (dl< '(4 5 6 7) '(5 6 7 8))    
;;; #t
;;; > (dl< '(4 5 6 0 0 0) '(3 4 5))
;;; #f
;;; > (dl< '(3 4 5 0 0 0) '(4 5 6))
;;; #t
;;; > (dl< '(3 4) '(4 3))
;;; #f
;;;

;;; greater than
;;; laziness but i'm out of time
;;; all i would do is copy dl> as dl< and create a dlGreat which
;;; would be dlLess with < changed to >
(define dl> (lambda (d1 d2) (dl< d2 d1)))