%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search
% Homework 3
% Name: Yoshi Fu
% Group: J
% Email: yoshifu2002@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1 (Ex 5.3 from the Lecture Notes: Euclid)

/**
 * Find the greatest common divisor between A and B using Euclid's Algorithm.
 *
 * The greatest common divisor between A and B is found by recursively finding
 * a GCD. Firstly, B is subtracted from A until a remainder is found that is
 * less than B. We then search for the greatest common divisor between B and
 * the remainder. This is repeated until the remainder equals zero, in which
 * case the other number is the greatest common divisor of A and B.
 *
 * Euclid's Algorithm: https://en.wikipedia.org/wiki/Euclidean_algorithm
 */
% Base case. If the remainder is 0, then the GCD is found.
gcd(A, 0, A) :- !.  % Do not backtrack to the second rule after solving.
% Recursive case. Keep changing A and B to B and remainder.
gcd(A, B, Result) :-
    Remainder is A mod B,
    gcd(B, Remainder, Result).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2 (Ex 5.4 from the Lecture Notes: occurrences/3)

/**
 * Find the number of occurrences of Elem in a List as N.
 *
 * Recursively iterate from head to tail over the List. If Elem is the head of
 * the list, then add 1 to the total number of occurances.
 */
% Base case. The empty list is a subset of every list.
occurrences(_, [], 0).  % If the list is empty, there are 0 occurrences.
% Recursive case (1). If Elem is the head, increment the number of occurrences.
occurrences(Elem, [Elem | Tail], N) :-
    occurrences(Elem, Tail, N0),
    !,  % If Elem is the head, do not try recursive case (2).
    N is N0 + 1.
% Recursive case (2). If Elem is not the head, continue with the tail of List.
occurrences(Elem, [_ | Tail], N) :-
    occurrences(Elem, Tail, N).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3 (splitting lists of integers)

% (a) separation/3

/**
 * Seperate the positives and negatives in a list of elements.
 *
 * Recursively iterate from head to tail over the list of elements. If the
 * element is positive, prepend it to the positives. Otherwise, prepend it
 * to the negatives. Note that zeroes are inserted into the list of positive
 * elements.
 */
% Base case. The empty list is a subset of every list.
separation([], [], []).  % The empty list is separated into empty lists.
% Recursive case (1). If Elem is greater than 0, prepend to positives.
separation([Elem | Tail], [Elem | Positives], Negatives) :-
    Elem >= 0,  % Elem belongs in positives if it is greater than 0.
    !,  % Prevent backtracking to recursive case (2).
    separation(Tail, Positives, Negatives).  % Continue seperating the rest.
% Recursive case (1). If Elem is smaller than 0, prepend to negatives.
separation([Elem | Tail], Positives, [Elem | Negatives]) :-
    separation(Tail, Positives, Negatives).  % Continue seperating the rest.

% (b) separationNoCut/3

% TODO instantly terminate instead of asking for ';'.
separationNoCut([], [], []).
separationNoCut([Elem | Tail], [Elem | Positives], Negatives) :-
    Elem >= 0,
    separationNoCut(Tail, Positives, Negatives).
separationNoCut([Elem | Tail], Positives, [Elem | Negatives]) :-
    Elem < 0,
    separationNoCut(Tail, Positives, Negatives).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4 (Ex 5.7 from Lecture Notes: voting power)

countries([belgium, france, germany, italy, luxembourg, netherlands]).

weight(france, 4).
weight(germany, 4).
weight(italy, 4).
weight(belgium, 2).
weight(netherlands, 2).
weight(luxembourg, 1).

threshold(12).

/**
 * Check if a coalition is winning in votes.
 *
 * A coalition is winning if the sum of their votes is greater than the
 * threshold of votes needed. The sum is computed by recursively iterating
 * from head to tail over the countries in the coalition and summing up
 * their respective weights.
 */
% Base case. Sum the total weight of Coalition, starting from 0.
winning(Coalition) :-
    winning(Coalition, 0).
% Recursive case (1). Check if the threshold is reached.
winning(_, Sum) :-
    threshold(Threshold),
    Sum >= Threshold,
    !.  % After finding solution, stop backtracking.
% Recursive case (2). If threshold is not reached, resume computation.
winning([Head | Tail], Sum) :-
    weight(Head, Weight),
    NewSum is Sum + Weight,
    winning(Tail, NewSum).

/**
 * Check if a country being part of the coalition is critical to win.
 *
 * A country is critical for winning if:
 *  i.   it is not part of the coalition.
 *  ii.  the coalition is currently losing.
 *  iii. the coalition is winning with the country.
 */
critical(Country, Coalition) :-
    \+ member(Country, Coalition),  % Verify that Country is not in Coalition.
    \+ winning(Coalition),  % Verify that Coalition is not winning.
    winning([Country | Coalition]).  % Verify that Coalition with Country is winning.

/**
 * Check if the first list is a sublist of the second list.
 *
 * The first list is a sublist of the second list if for each element in the
 * first list there exists a copy in the second list. To do this recursively,
 * we check if the heads are identical. If that is the case, check if the first
 * tail is a sublist of the second tail. It it is not the case, still check if
 * the first tail is a sublist of the second tail. We still check for sublists
 * that do not contain the head that was discarded. Note that the lists have
 * to be ordered.
 */
% Base case. The empty list is a subset of every list.
sublist([], []).
% Recursive case (1). If the heads are equal, check if Tail1 is sublist of Tail2.
sublist([Head | Tail1], [Head | Tail2]) :-
    sublist(Tail1, Tail2).
% Recursive case (2). If the heads are not equal, check if List is sublist of Tail.
sublist(List, [_ | Tail]) :-
    sublist(List, Tail).

/**
 * Compute the voting power of a country.
 *
 * The voting power is the number of cases where the Country is critical in the
 * outcome of the vote. To compute this, we find all possible coalitions and
 * check if the Country is critical.
 *
 * Note that critical/2 checks if Country is already in Coalition.
 */
voting_power(Country, Power) :-
    Goal = (
        countries(All),  % Find all countries.
        sublist(Coalition, All),  % Find all possible coalitions.
        critical(Country, Coalition)  % Verify if Country is critical.
    ),
    findall(Coalition, Goal, Bag),  % Find all cases where Country is critical.
    length(Bag, Power).  % Count the number of times where Country is critical.

% What is the voting power of Germany?
% ?- voting_power(germany, Power).
% Power = 10.

% How about Luxembourg?
% ?- voting_power(luxembourg, Power).
% Power = 0.

% Explain what this means for the voting rule used.
% With the voting rule used, Luxembourg has 0 power in the outcome of the vote.
% This means that the vote of Luxembourg has no impact on the outcome. This
% means that the voting rule used is unfair in the perspective of Luxembourg.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5 (dynamic counter)

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bonus Question 6 (robot navigation)

% ...



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declaration
%
% I hereby declare that these solutions are entirely my own work and no part has been copied from other sources.
%
% Number of LC hours I attended this week: 4
%
% Additional hours I spent on the homework: 6
