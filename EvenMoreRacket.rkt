#lang racket
(define (average mylist)
  (/ (foldr (lambda (lst total)
           (+ total lst)
  )
         0 mylist) (length mylist))
  )
;(average (list 4 5 6) )

(define (duple mylist)
(map (lambda (lst)
         (list  lst lst)
  )
       mylist)
  )
;(duple (list 4 5 6))

(define (convertFC mylist)
  (map (lambda (number)
          (*(- number 32) (/ 5 9)))
       mylist))
;(convertFC (list 5 6 7) )

(define (check-temps1 mylist)

 (cond [(equal? #f(list? (memv #f(map (lambda (number)
       
     (and (<= 5 number) (>= 95 number))

  ) mylist))))#t]
       [else #f])
  )


;(check-temps1 (list 8))  

(define (check-temps mylist num1 num2)
(cond [(equal? #f(list? (memv #f(map (lambda (number)
       
     (and (<= num1 number) (>= num2 number))

  ) mylist))))#t]
       [else #f])
  )
  
;(check-temps (list 8) 5 10)

(define (convert num)
  (define power 1)
  (/(foldl(lambda (number result)
        (set! power(* power 10))
          (+ result (* number power))  )
        0 num)10))
;(convert (list 1 2 3))


(define (eliminate-larger lst)
  (foldr (lambda (x y result)
           [if(< x (first result))
              (cons x result) result ] )
         (list (last lst) ) lst lst ) )
  


(define (curry2 f)
  (lambda (ar1)
    (lambda (ar2)
      (f ar1 ar2))))


