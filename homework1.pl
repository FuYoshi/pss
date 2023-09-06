%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search
% Homework 1
% Name: Yoshi Fu
% Group: J
% Email: yoshifu2002@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1

/* Facts about students and their TA. */
has_ta(alice, noa).
has_ta(bob, noa).
has_ta(carol, johan).
has_ta(yoshi, sacha).

/* Facts about TAs and their favourite text editor. */
has_favourite_editor(noa, vim).
has_favourite_editor(malvin, emacs).
has_favourite_editor(johan, 'VS Code').
has_favourite_editor(sacha, 'VS Code').


/**
 * State the favourite text editor of the TA of a student.
 *
 * Arguments:
 *      Student:
 *          A student with a TA that has a favourite text editor.
 *
 * Returns:
 *      true if Student has a TA and the TA has a favourite text editor.
 *      false otherwise.
 *
 * Side Effects:
 *      Writes the favourite text editor of the TA of the student.
 */
answer(Student) :-
    has_ta(Student, TA),  % Check if Student has a TA.
    has_favourite_editor(TA, Editor),  % Check if TA has a favourite text editor.
    write('The favourite text editor of the TA of this student is '),
    write(Editor),
    write('.').


% Question 1-C
% Input/Output example.
% ?- answer(yoshi).
% The favourite text editor of the TA of this student is VS Code.
% true.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2 (1.3 in the Lecture Notes, family relations)

% Here is again the family database:

female(mary).
female(sandra).
female(juliet).
female(lisa).
male(peter).
male(paul).
male(dick).
male(bob).
male(harry).
parent(bob, lisa).
parent(bob, paul).
parent(bob, mary).
parent(juliet, lisa).
parent(juliet, paul).
parent(juliet, mary).
parent(peter, harry).
parent(lisa, harry).
parent(mary, dick).
parent(mary, sandra).

/**
 * Check if Father is the father of Child.
 *
 * Parameters:
 *      Father:
 *          Person to check if it is a father of Child.
 *      Child:
 *          Person to check the father of.
 *
 * Returns:
 *      true if Father is the father of Child.
 *      false otherwise.
 */
father(Father, Child) :-
    male(Father),  % Check if Father is a male.
    parent(Father, Child).  % Check if Father is a parent of Child.

/**
 * Check if Sister is the sister of Sibling.
 *
 * Parameters:
 *      Sister:
 *          Person to check if it is a sister of Sibling.
 *      Sibling:
 *          Person to check the sister of.
 *
 * Returns:
 *      true if Sister is the sister of Sibling.
 *      false otherwise.
 */
sister(Sister, Sibling) :-
    female(Sister),  % Check if Sister is a female.
    parent(Parent, Sister),  % Check if Sister has a parent.
    parent(Parent, Sibling),  % Check if Sibling has the same parent.
    Sister \= Sibling.  % Check that Sister and Sibling are not the same.

/**
 * Check if Grandmother is the grandmother of Child.
 *
 * Parameters:
 *      Grandmother:
 *          Person to check if it is a Grandmother of Child.
 *      Child:
 *          Person to check the grandmother of.
 *
 * Returns:
 *      true if Grandmother is the grandmother of Child.
 *      false otherwise.
 */
grandmother(Grandmother, Child) :-
    female(Grandmother),  % Check if Grandmother is a female.
    parent(Grandmother, Parent),  % Check if Grandmother is a parent of Parent.
    parent(Parent, Child).  % Check if Parent is parent of Child.


/**
 * Limitations and Problems:
 *      - The program does not understand the concept of remarrying. Therefore
 *        stepsiblings could be interpreted as siblings by the program.
 *      - The program does not understand the concept of rape/polygamy.
 *        Therefore some stepsiblings are misinterpreted as siblings.
 *      - The program does not understand the concept of adoptation.
 *      - The program cannot accurately describe the relation of the oldest
 *        generation. If the oldest generation in the database is the generation
 *        of the grandfather, then two grandfather could be brothers. The
 *        program can not verify this as it would search for a common
 *        grand-grandparent, which does not exist in the database.
 */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3 (2.1 in the Lecture Notes, analyse_list)


/**
 * State the Head and Tail of a list. If the list is empty, state that instead.
 *
 * Parameters:
 *      Head:
 *          First element of the list.
 *      Tail:
 *          The remaining part of the list without the first element.
 *
 * Returns:
 *      true if Head and Tail is found or list is empty.
 *      false otherwise.
 *
 * Side Effects:
 *      Writes the Head and Tail of the list or writes that the list is empty.
 */
analyse_list([]) :-  % Check for empty list.
    write('This is an empty list.').
analyse_list([Head | Tail]) :-  % Check for Head and Tail in list.
    write('This is the head of your list: '),
    write(Head), nl,
    write('This is the tail of your list: '),
    write(Tail).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4 (2.2 in the Lecture Notes, membership)


/**
 * State if Elem is a member of the list.
 *
 * Parameters:
 *      Elem:
 *          Element to check for.
 *      List:
 *          List to check for Elem.
 *
 * Returns:
 *      true if Elem is member of List.
 *      false otherwise.
 */
membership(Elem, [Elem | _]) :- true.
membership(Elem, [_ | Tail]) :- membership(Elem, Tail).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5 (2.6 in the Lecture Notes, last1 and last2)


/**
 * State the last element in List.
 *
 * Parameters:
 *      Last:
 *          Element to check for.
 *      List:
 *          List to check for Last.
 *
 * Returns:
 *      true if Last is the last element of List.
 *      false otherwise.
 */
last1([Last], Last) :- true.
last1([_ | Tail], Last) :- last1(Tail, Last).

/**
 * State the last element in List. Note that this implementation uses append/3
 * so there is less recursion.
 *
 * Parameters:
 *      Last:
 *          Element to check for.
 *      List:
 *          List to check for Last.
 *
 * Returns:
 *      true if Last is the last element of List.
 *      false otherwise.
 */
last2(List, Last) :- append(_, [Last], List).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6 (2.10 in the Lecture Notesunary numbers)


/**
 * Get the successor of two unary numbers.
 *
 * Parameters:
 *      Number:
 *          Unary number.
 *      Successor:
 *          Successor of the unary number.
 *
 * Returns:
 *      true if successor is computable.
 *      false otherwise.
 */
successor(Number, Successor) :- append(Number, [x], Successor).

/**
 * Sum two unary numbers.
 *
 * Parameters:
 *      Num1:
 *          First unary number.
 *      Num2:
 *          Second unary number.
 *      Sum:
 *          Sum of the two numbers.
 *
 * Returns:
 *      true if sum is computable.
 *      false otherwise.
 */
plus(Num1, Num2, Sum) :- append(Num1, Num2, Sum).

/**
 * Multiply two unary numbers.
 *
 * Parameters:
 *      Num1:
 *          First unary number.
 *      Num2:
 *          Second unary number.
 *      Product:
 *          Product of the two numbers.
 *
 * Returns:
 *      true if multiplication is computable.
 *      false otherwise.
 */
times([], _, []).  % Multiplication with 0 equals 0.
times([_ | Tail], Num2, Product) :-
    append(Num2, Num1, Product),  % Append Num1 to Num2.
    times(Tail, Num2, Num1).  % Repeat for each element in Num1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bonus Question 7 (bulldoze)


/**
 * Bulldoze a list into a single dimension.
 *
 * Parameters:
 *      List:
 *          The list to bulldoze.
 *      Bulldozed:
 *          The resulting list after bulldozing.
 *
 * Returns:
 *      true if the list is bulldozable.
 *      false otherwise.
 */
/* An empty list is already bulldozed. */
bulldoze([], []).
/* Bulldoze a list by bulldozing the head and tail and then appending them. */
bulldoze([Head | Tail], Bulldozed) :-
    bulldoze(Head, Bulldozed_Head),  % Bulldoze the head.
    bulldoze(Tail, Bulldozed_Tail),  % Bulldoze the tail.
    append(Bulldozed_Head, Bulldozed_Tail, Bulldozed).  % Combine the parts.
/* Otherwise, prepend the single element Head and bulldoze the tail. */
bulldoze([Head | Tail1], [Head | Bulldozed_Tail]) :-
    bulldoze(Tail1, Bulldozed_Tail).  % Bulldoze the tail.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declaration
%
% I hereby declare that these solutions are entirely my own work and no part has been copied from other sources.
%
% Number of LC hours I attended this week: 4
%
% Additional hours I spent on the homework: 4
