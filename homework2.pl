%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search
% Homework 2
% Name: Yoshi Fu
% Group: J
% Email: yoshifu2002@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1 (sublist)

/**
 * Check if the first list is a subset of the second list.
 *
 * This is done by checking if the Head of the first list is in the second list
 * using select/3. The element is then removed from the second list resulting
 * in NewList. This is repeated using the tail of the first List to check for
 * every element. The NewList is used in recursion instead of List to allow
 * the same element to occur multiple times in the first List.
 */
sublist([], _).
sublist([Elem | Tail], List) :-
    select(Elem, List, NewList),  % Check if Elem is in List and remove it.
    sublist(Tail, NewList).  % Check if the other elements are in the list.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2 (drawing triangles)

% (a) line/2

/**
 * Repeat a symbol n times.
 *
 * This is done by writing the symbol once and then recursively call the
 * predicate with n - 1. Eventually n = 0, which satisfies the predicate.
 */
line(0, _).  % Satisfy the predicate when it is done writing.
line(N, Symbol) :-
    write(Symbol),  % Write the symbol once.
    M is N - 1,  % Subtract 1 from N, this is the remaining amount to repeat.
    line(M, Symbol).  % Repeat the symbol M times.

% (b) draw/2

/**
 * Write '*' M times in a line and increment M, repeat until M > N.
 *
 * This is done by calling line(M, *) and writing a newline. Recursively call
 * the predicate everytime M is incremented.
 */
draw(N, N) :-
    line(N, *).  % If M and N are equal, write the line and stop.
draw(M, N) :-
    M =< N,  % Check if M is less than or equal to N.
    line(M, *), nl,  % Write * M times in a line.
    SuccM is M + 1,  % Compute the succesor of M.
    draw(SuccM, N).  % Continue with SuccM until a stop condition is found.


% (c) triangle/1

% Write a triangle with height N.
triangle(N) :- draw(1, N).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3 (Ex 4.1 (a) from Lecture Notes: plink/plonk)

:- op(100, yfx, plink),
   op(200, xfy, plonk).

/* tiger plink dog plink fish = X plink Y.
(i)
plink is right associative, so it the right plink is evaluated first. The
expression to the left of the right-most plink is assigned to X and the
expression to the right of the right-most plink is assigned to Y.

(ii) cow plonk elephant plink bird = X plink Y.
Plink has a stronger presedence, so the expression can be seen as:
cow plonk (elephant plink bird) = X plink Y.
This obviously fails as plink and plonk are not the same operator.

(iii) X = (lion plink tiger) plonk (horse plink donkey).
The expression has brackets around each occurance of plink to prioritize it
over the plonk. The plink operator has a stronger presedence than plonk so,
the brackets are unnecessary. Therefore, X is evaluated to the experssion
with the brackets removed.
*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4

% (a) yfy

/*
An operator with pattern yfy, would raise problems when it occurs more than
once in a predicate. In the example below,
    a yfy b yfy c
The left yfy wants to prioritize 'b yfy c', while the
the right yfy wants to prioritize 'a yfy b'. This is a contradiction and does
not allow the computer to know the exact order of evaluation.
*/

% (b) bli bla
% ?- bla bla blabla bli bla blabla = bla X bli X.
% ?- a bli b bli c \= (a bli b) bli c.
% ?- blibli bli blibli blu = blu(_).
/*
The second predicate suggests that bli if infix. The left side is not equal
to the right side and the right side is left-associative. Therefore, it is
right-associative or non-associative. The left side tells us that it cannot
be non-associative as it would cause a syntax error.
*/
:- op(600, xfy, bli).
/*
bla is a prefix operator as seen in the first expression. It is associative as
it can be used twice as seen in the first expression ('bla bla X'). bla should
have stronger presedence so that in the first expression the following happens:
bla bla blabla bli bla blabla
= bla (bla blabla) bli (bla blabla)
= bla X bli X.
*/
:- op(500, fy, bla).
/*
blabla and blabla should be a atoms so that the first and third predicate
are not entirely made out of operators.
*/
blabla.
blibli.
/*
blu should be post fix according to the third predicate.
TODO associativity explaination
*/
:- op(600, yf, blu).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5 (Ex 3.3 and 3.4 from Lecture Notes: Fibonacci)

% (a) Fibonacci

/**
 * Compute the Nth fibonacci number as F.
 *
 * This is done by recusively computing the N-1th and N-2th terms in the
 * fibonacci sequence and summing them up.
 */
fibonacci(0, 0).  % The 0th fibonacci number is 0.
fibonacci(1, 1).  % The 1st fibonacci number is 1.
fibonacci(N, F) :-
    N > 1,  % For any fibonaccy number after the 1st.
    A is N - 1,  % Get the index of N-1.
    B is N - 2,  % Get the index of N-2.
    fibonacci(A, FA),  % Compute the N-1th fibonacci number.
    fibonacci(B, FB),  % Compute the N-2th fibonacci number.
    F is FA + FB.  % Compute the sum of the N-1th and N-2th fibonacci terms.

% (b) Fast Fibonacci

/*
Brief explaination of the problem.

The problem of fibonacci/2 is that it starts two recursive calls each step.
Eventually the computer runs out of memory to store all the recursive steps
and has to abort the instruction. To prevent this, the N-1th term can be
passed forward so less recursive calls can be made.
*/

/**
 * Compute the Nth fibonacci number as F.
 *
 * This is done by recusively computing the N-2th term in the fibonacci
 * sequence and summing them up with the N-1th term. Note that fastfibo
 * has a 3 parameter predicate that saves the N-1th term. This term can
 * be computed in a previous iteration and is passed forward. This way,
 * less recursive calls can be made.
 */
fastfibo(0, 0).  % The 0th fibonacci number is 0.
fastfibo(N, F) :-
    N > 0,  % The other fibonacci numbers all have positive N.
    fastfibo(N, F, _).  % Use the other predicate with 3 parameters.
fastfibo(1, 1, 0).  % If N = 1 then the fibonacci number is 1.
fastfibo(N, F, Last) :-
    N > 1,  % The other fibonacci numbers all have positive N.
    Prev is N - 1,  % Compute the predecessor of N.
    fastfibo(Prev, Last, Last2),  % Compute the N-2th fibonacci number as Last2.
    F is Last + Last2.  % F is the sum of the previous two fibonacci numbers.

% What is the 42nd Fibonacci number?
% ?- fastfibo(42, F).
% F = 267914296 .


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6 (Ex 3.9 from Lecture Notes: People)

born(jan, date(20,3,1977)).
born(jeroen, date(2,2,1992)).
born(joris, date(17,3,1995)).
born(jelle, date(1,1,2004)).
born(jesus, date(24,12,0)).
born(joop, date(30,4,1989)).
born(jannecke, date(17,3,1993)).
born(jaap, date(16,11,1995)).

% (a)
/* Check if there exists an atom with Year as year value in date(). */
year(Year, Person) :-
    born(Person, date(_, _, Year)).

% (b)
/**
 * Check if the first date is strictly before the second date.
 *
 * This is done by first comparing the years. If the years are equal, compare
 * the months. If the months are also equal, compare the days.
 */
before(date(_, _, Y1), date(_, _, Y2)) :- Y1 < Y2.  % Compare years.
before(date(_, M1, Y), date(_, M2, Y)) :- M1 < M2.  % Compare months.
before(date(D1, M, Y), date(D2, M, Y)) :- D1 < D2.  % Compare days.

/**
 * Check if person X is strictly older than person Y.
 *
 * This is done by checking if X was born strictly before Y.
 */
older(X, Y) :-
    born(X, XBorn),
    born(Y, YBorn),
    before(XBorn, YBorn).

/*
You should get 28 solutions for the query older(X, Y). Explain why.

Since there are 8 people in the database and we want to know every combination
where one person is strictly older than another person, we can create an
ordering. The oldest person would have 0 people older than them, the second
oldest person would have 1 people older than them, and so on. Therefore,
the amout of solutions we should get is 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28.
Note that this pattern only works because there are no people born on the same
date in the database. For each such duplicate date the number of solutions
would be decremented.
*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bonus Question 7 (Ex 3.13 from Lecture Notes: Goldbach)


/**
 * Check if X is not a prime number.
 *
 * This is done by checking if X is divisible by any other number.
 * X is divisible by a number Y if the remainder after division is 0.
 *
 * Note that we only have to check the numbers from 2 to sqrt(X). The reason is
 * that if there was any number after the sqrt(X) that was a factor, the other
 * factor would have to be smaller than the sqrt(X). This means that we have
 * already checked these possible candidates priorly.
 */
notPrime(X, Y) :-
    X > Y,  % Check if X is greater than Y. Otherwise, it can't be divisible.
    0 is X mod Y.  % Check if the remainder after division is 0.
notPrime(X, Y) :-
    sqrt(X, Upper),  % Compute the upper bound to check for.
    Upper >= Y + 1,  % Increment Y as long as it does not exceed the limit.
    notPrime(X, Y + 1).  % Check if X is divisible by the new Y.

/**
 * Check if N is a prime number.
 *
 * This is done by checking if N is greater than two and checking if it is
 * not not prime. In other words, if the number is not divisible by any other
 * number.
 */
prime(2).  % 2 is the smallest prime number and therefore the base case.
prime(N) :-
    N > 2,  % Check if the number is greater than 2 (the smallest prime).
    not(notPrime(N, 2)).  % Check if N is not not prime.

/**
 * Check if N is a sum of two primes A and B. S is the expression 'A+B'.
 *
 * This is done by choosing A > 2 and B = N - A and check if they are both
 * prime. If that is the case, then a solution is found. If that is not the
 * case, A is incremented and B is recomputed. We again check if the new A
 * and B are prime. This process is repeated until an upperbound is reached.
 *
 * The upperbound is currently set to N / 2. This is because any value higher
 * has already been checked for. The A and B terms would just be swapped.
 */
goldbach(N, S) :-
    U is round(N / 2),  % Set the upperbound to N / 2.
    goldbach(2, 2, U, N, S).  % Try A=2 as the first option in range [2, N/2].
goldbach(A, L, U, N, S) :-
    between(L, U, A),  % Check if A is in range [L, U].
    prime(A),  % Check if A is prime.
    B is N - A,  % Compute B to be N - A, since A and B have to sum up to N.
    prime(B),  % Check if B is prime.
    S = A + B.  % Satisfy the predicate and provide the solution.
goldbach(A, L, U, N, S) :-
    A1 is A + 1,  % Increment A.
    goldbach(A1, L, U, N, S).  % Try again with a higher A value.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declaration
%
% I hereby declare that these solutions are entirely my own work and no part has been copied from other sources.
%
% Number of LC hours I attended this week: ...
%
% Additional hours I spent on the homework: ...
