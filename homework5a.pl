%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search
% Name: Yoshi Fu
% Group: J
% Email: yoshifu2002@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework #5 Part A: The Numbers Game
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1: move/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Move by using an operator between two expressions in Terms.
 * A node consists of a target value Target and a list of expressions Terms.
 */
% addition case.
move(Target:Terms, Target:NewTerms) :-
    select(Exp, Terms, Terms1),
    select(Exp2, Terms1, Terms2),
    NewTerms = [Exp+Exp2 | Terms2].
% subtraction case.
move(Target:Terms, Target:NewTerms) :-
    select(Exp, Terms, Terms1),
    select(Exp2, Terms1, Terms2),
    NewTerms = [Exp-Exp2 | Terms2].
% multiplication case.
move(Target:Terms, Target:NewTerms) :-
    select(Exp, Terms, Terms1),
    select(Exp2, Terms1, Terms2),
    NewTerms = [Exp*Exp2 | Terms2].
% division case.
move(Target:Terms, Target:NewTerms) :-
    select(Exp, Terms, Terms1),
    select(Exp2, Terms1, Terms2),
    \+ 0 is Exp2,  % Disallow division by 0.
    0 is Exp mod Exp2,  % Only allow division if the result is an integer.
    NewTerms = [Exp/Exp2 | Terms2].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2: goal/1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Check if a node fulfills the condition of the goal.
 * This is when the left-most expression in the terms list evaluates to the
 * target value.
 */
goal(Target:Terms) :-
    member(Exp, Terms),
    Target is Exp,
    !.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3: solve/3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Find the solution to obtain target value Target from the terms Terms.
 */
solve(Target, Terms, Solution) :-
    solve_iterative_deepening(Target:Terms, Path),
    % solve_breadthfirst(Target:Terms, Path),
    % solve_depthfirst(Target:Terms, Path),
    % solve_depthfirst_cyclefree(Target:Terms, Path),
    last(Path, Target:[Solution | _]),
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4: examples and explanations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Example 1.
?- solve(17, [5,5,5], Solution).
false

Example 2.
?- solve(30030, [2,3,5,7,11,13], Solution).
Solution = 2*3*5*7*11*13.

Example 3.
?- solve(6, [2,2,2,3], Solution).
Solution = 2*3.

What happens when you use other search algorithms than iterative deepening?
Iterative deepening will go into an infinite loop when there is no solution,
while other search algorithms could halt and return false. This is the case
for example 1 above.

Does breadth-first search work as well? Can you explain why?
No, BFS could find out that a problem is impossible to solve. The problem is
when the solution requires many uses of the operators to occur. Every time a
choice for a operator is possible, a node can be split into 4 different nodes.
This means that for a solution that requires n operators, BFS would have to
store 4^(n-1) nodes in memory before potentially finding the solution in the
next move. This implies that there is a high chance that BFS will not find
solutions to complex problems due to insufficient memory. This is the case for
example 2.

How about depth-first search?
DFS will find the solution to the problem if there is one or return false when
it is impossible. This is because unlike BFS, it does not need an exponential
amount of memory to search for the solution. The only way it does not find a
solution is when it is in a branch with infinite moves. This is not possible
as the list of terms contains 6 positive integers (according to the text).

Does it make a difference whether or not you use the cycle-free version of
depth-first search? Why?
No, since there are no cycles for this problem. DFS cyclefree only ignores
visited notes in the same branch. It is not possible to perform a move which
adds operators and results in a previously visited node that has less
operators.

Can you explain why depth-first search tends to produce solutions involving
more of the input numbers than iterative deepening?
Iterative deepening attempts increases its bound until it finds a solution.
Since the bound is incremented by 1 each time, it will find the shortest
solution possible. In this case, making less moves implies using less operators
and therefore less of the input numbers. On the other hand, DFS could find a
solution that takes more moves than the shortest answer and therefore use more
input numbers.
 */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic Search Algorithms                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Below you can find the relevant implementations of the
% basic search algorithms from the slides. You do not have
% to modify them and you do not need to comment them.

% Auxiliary predicate: wrapper around move/2.

move_cyclefree(Visited, Node, NextNode) :-
  move(Node, NextNode),
  \+ member(NextNode, Visited).

% Simple depth-first search:

solve_depthfirst(Node, [Node|Path]) :-
  depthfirst(Node, Path).

depthfirst(Node, []) :-
  goal(Node).

depthfirst(Node, [NextNode|Path]) :-
  move(Node, NextNode),
  depthfirst(NextNode, Path).

% Cycle-free depth-first search:

solve_depthfirst_cyclefree(Node, Path) :-
  depthfirst_cyclefree([Node], Node, RevPath),
  reverse(RevPath, Path).

depthfirst_cyclefree(Visited, Node, Visited) :-
  goal(Node).

depthfirst_cyclefree(Visited, Node, Path) :-
  move_cyclefree(Visited, Node, NextNode),
  depthfirst_cyclefree([NextNode|Visited], NextNode, Path).

% Depth-bounded depth-first search:

solve_depthfirst_bound(Bound, Node, Path) :-
  depthfirst_bound(Bound, [Node], Node, RevPath),
  reverse(RevPath, Path).

depthfirst_bound(_, Visited, Node, Visited) :-
  goal(Node).

depthfirst_bound(Bound, Visited, Node, Path) :-
  Bound > 0,
  move_cyclefree(Visited, Node, NextNode),
  NewBound is Bound - 1,
  depthfirst_bound(NewBound, [NextNode|Visited], NextNode, Path).

% Breadth-first search:

solve_breadthfirst(Node, Path) :-
  breadthfirst([[Node]], RevPath),
  reverse(RevPath, Path).

breadthfirst([[Node|Path]|_], [Node|Path]) :-
  goal(Node).

breadthfirst([Path|Paths], SolutionPath) :-
  expand_breadthfirst(Path, ExpPaths),
  append(Paths, ExpPaths, NewPaths),
  breadthfirst(NewPaths, SolutionPath).

expand_breadthfirst([Node|Path], ExpPaths) :-
  findall([NewNode,Node|Path], move_cyclefree(Path,Node,NewNode), ExpPaths).

% Iterative deepening:

solve_iterative_deepening(Node, Path) :-
  path(Node, GoalNode, RevPath),
  goal(GoalNode),
  reverse(RevPath, Path).

path(Node, Node, [Node]).

path(FirstNode, LastNode, [LastNode|Path]) :-
  path(FirstNode, PenultimateNode, Path),
  move_cyclefree(Path, PenultimateNode, LastNode).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declaration
%
% I hereby declare that these solutions are entirely my own work and no part has been copied from other sources.
%
% Number of LC hours I attended this week: 4
%
% Additional hours I spent on the homework: 2
