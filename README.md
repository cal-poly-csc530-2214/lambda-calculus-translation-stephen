# lambda-calculus-translation-stephen

Assignment 2 for CSC 530 Spring 2021 at CP SLO. 

A Compiler that accepts terms in lambda calculus and outputs Javascript according to ECMA-262. 

The grammer is the following:

```
LC	 	=	 	num
 	 	|	 	id
 	 	|	 	(/ id => LC)
 	 	|	 	(LC LC)
 	 	|	 	(+ LC LC)
 	 	|	 	(* LC LC)
 	 	|	 	(ifleq0 LC LC LC)
 	 	|	 	(println LC)
```

where num is a number, and id is an identifier.

## Process

Since I do not have any experience with Racket, I first played around with learning how to create functions, if-else statements, switch statements (case and match), and typing. My first attempt was using strings as the input such as `"/ id => (+ 3 4)"` however I ran into a blocker where the `read` function I was using to tokenize the LC and returning it in an array was returning elements as a S-Expression (or Sexp in typed/racket also similar to syntax->datum) which I could not figure out how to convert to Strings (and I wasn't clear if I should even do this). So I ended up switching to using Sexp as the input which would look like `'(/ id => (+ 3 4))`, this simplified a large portion of the code and the rest was fairly clear.

I tried to make sure nested LCs were applicable by testing thoroughly however nested lambdas may not be applicable due to my uncertainty on how to give the lambda names (if they should have one).

Overall, this was a great exercise for introducing Racket and understanding LC grammer.
