#lang racket

(define (check-temps1_helper temps)
  (cond
   [(empty? temps) empty]
   [else (cons(and (< 5 (first temps)) (> 95 (first temps)))  (check-temps1_helper  (rest temps)))]))


(define (check-temps1 templist)
  (cond
    [(equal? #f (list?( memv #f( check-temps1_helper templist)))) #t]
    [else #f]
    )
  )

(define (check-temps_helper temps lower upper)
  (cond
   [(empty? temps) empty]
   [else (cons(and (< lower (first temps)) (> upper (first temps)))  (check-temps_helper  (rest temps) lower upper))]))

(define (check-temps templist lower upper)
  (cond
  [(equal? #f(list?( memv #f( check-temps_helper templist lower upper)))) #t]
  [else #f]))


(define (total lst)
  (cond
    [ (empty? lst) 0]
    [else (+ (first lst)(total (rest lst)))]))

(define (average  lst)
  (cond
   [(empty? lst) 0]
   [else
    (/(total lst) (length lst))]
  ))

(define (convert digits [power 1])
 (if (empty? digits)
     0
     (+ (* power (first digits))
        (convert (rest digits) (* power 10)))) 
)

(define (duple lst)
  (cond
   [(empty? lst) empty]
   [else (cons (list (first lst) (first lst) )  (duple  (rest lst)))]))

(define (convertover number)
(*(- number 32) (/ 5 9))
  )
(define (convertFC temps)
  (cond
    [(empty? temps)empty]
    [else (cons (convertover(first temps)) (convertFC (rest temps)))]))
    
(define (eliminate-larger lst)
  (if (empty? lst)
    empty
    (reverse
      (append
        (list (first (reverse lst)))
        (eliminate-largerhelper
          (rest (reverse lst))
          (first (reverse lst)))))))

(define (eliminate-largerhelper lst helperlist)
  (cond
    [(empty? lst) empty]
    [else
      (cond
        [(> (first lst) helperlist)
          (eliminate-largerhelper (rest lst) helperlist)]
        [else
          (append
            (list (first lst))
            (eliminate-largerhelper (rest lst) (first lst)))])])
            )

(define (get-nth lst n [index 0])
 (cond
   [(empty? lst) -1]
   [(equal? n index) (first lst)]
   [else (get-nth (rest lst) n ( + index 1))]
  )
  )

(define (find-item lst n [index 0])
 (cond
   [(empty? lst) -1]
   [(equal? (first lst) n) index] 
  [else (find-item (rest lst) n (+ index 1))]))

