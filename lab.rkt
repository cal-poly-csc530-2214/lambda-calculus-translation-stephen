#lang typed/racket

(require typed/rackunit)

#|

 LC = num
    | id
    | (/ id => LC)
    | (LC LC)
    | (+ LC LC)
    | (* LC LC)
    | (ifleq0 LC LC LC)
    | (println LC)
|#

(define (lc [str : Sexp]) : String
  (match str
    ;; LC: num
    ;; JS: num
    [(? number? str) (number->string str)]

    ;; LC: id
    ;; JS: id
    [(? symbol? str) (symbol->string str)]
    
    ;; LC: ( / id => LC)
    ;; JS: lambda = id => LC(ID)
    [(list '/ id '=> expr)
       (string-append "lambda = " (lc id) " => " (lc expr))]

    ;; LC: (+ LC_1 LC_2)
    ;; JS: LC_1 + LC_2
    [(list '+ expr1 expr2)
       (string-append (lc expr1) " + " (lc expr2))]

    ;; LC: (* LC_1 LC_2)
    ;; JS: LC_1 * LC_2
    [(list '* expr1 expr2)
       (string-append (lc expr1) " * " (lc expr2))]

    ;; LC: (ifleq0 LC_1 LC_2 LC_3)
    ;; JS: (LC_1 <= 0) ? LC_2 : LC_3
    [(list 'ifleq0 var expr_then expr_else)
       (string-append "( " (lc var) " <= 0) ? " (lc expr_then) " : " (lc expr_else))]

    ;; LC: (println LC)
    ;; JS: console.log(LC)
    [(list 'println expr)
       (string-append "console.log('" (lc expr) "')")]

    ;; LC: (LC_1 LC_2)
    ;; JS: LC_1(LC_2)
    [(list expr1 expr2)
       (string-append (lc expr1) "(" (lc expr2) ")")
       ]
    
    ;; Error, no match
    [_
       (error "Problem with Expression, match not found?")
       ]
  )
)

;; (check-equal? (lc ') "")

;; Num Testing
(displayln "Num Testing...")
(check-equal? (lc '9) "9")
(check-equal? (lc '-1) "-1")
(check-equal? (lc '0) "0")
(check-equal? (lc '2147483649) "2147483649")


;; Symbol Testing
(displayln "Symbol Testing...")
(check-equal? (lc 'a) "a")
(check-equal? (lc 'abc) "abc")
(check-equal? (lc 'sixers6) "sixers6")
(check-equal? (lc 'a_b) "a_b")

;; Lambda Testing
(displayln "Lambda Testing...")
(check-equal? (lc '(/ id => 9)) "lambda = id => 9")
(check-equal? (lc '(/ id => -1)) "lambda = id => -1")
(check-equal? (lc '(/ id => 0)) "lambda = id => 0")
(check-equal? (lc '(/ id => 2147483649)) "lambda = id => 2147483649")

(check-equal? (lc '(/ id => a)) "lambda = id => a")
(check-equal? (lc '(/ id => abc)) "lambda = id => abc")
(check-equal? (lc '(/ id => sixers6)) "lambda = id => sixers6")
(check-equal? (lc '(/ id => a_b)) "lambda = id => a_b")

(check-equal? (lc '(/ id => (/ ie => a)  )) "lambda = id => lambda = ie => a")

(check-equal? (lc '(/ id => (+ 4 5))) "lambda = id => 4 + 5")
(check-equal? (lc '(/ id => (* 4 5))) "lambda = id => 4 * 5")
(check-equal? (lc '(/ id => (ifleq0 4 (println neg) (println pos) ))) "lambda = id => ( 4 <= 0) ? console.log('neg') : console.log('pos')")

;; Apply Testing
(displayln "Apply Testing...")
(check-equal? (lc '(a b)) "a(b)")

;; Plus Testing
(displayln "Plus Testing...")
(check-equal? (lc '(+ 4 5)) "4 + 5")
(check-equal? (lc '(+ -9 3)) "-9 + 3")
(check-equal? (lc '(+ 87 -109)) "87 + -109")

;; Multiplication Testing
(displayln "Multiplication Testing...")
(check-equal? (lc '(* 4 5)) "4 * 5")
(check-equal? (lc '(* -9 3)) "-9 * 3")
(check-equal? (lc '(* 87 -109)) "87 * -109")

;; ifleq0 Testing
(displayln "ifleq0 Testing...")
(check-equal? (lc '(ifleq0 -1 (print a) (print b))) "( -1 <= 0) ? print(a) : print(b)")

;; println Testing
(displayln "println Testing...")
(check-equal? (lc '(println test)) "console.log('test')")









