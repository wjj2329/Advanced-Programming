#lang racket

;weird new functions for lab 4
(define (default-parms f values)
  (lambda args
    (cond
    [(> (length values)(length args) ) (apply f (append args (list-tail values (length args))))] ;not enough args  
    [else (apply f args)]) ;we are good to go!!!!!!!
    )
  )

(define (check-types types parms)
  (cond   
  [(empty? types) #t] ;just return true
      [else
       (if ((first types) (first parms))
          (check-types (rest types) (rest parms))
           (error "invalid argument(s)"))]
      )
  )

(define (type-parms f types)
  (lambda args
    (cond
    [(check-types types args)
        (apply f args)]
      [else (error "invalid argument(s)")])))

;from lab1
(define (degrees-to-radians angle)
  (* angle (/ pi 180)))

(define (new-sin angle type)
  (cond
    ((symbol=? type 'degrees)
      (sin (degrees-to-radians angle)))
    ((symbol=? type 'radians)
      (sin angle))
  )
)
;new sin for this lab
(define new-sin2
  (default-parms (type-parms new-sin (list number? symbol?))
    (list 0 'radians)))
