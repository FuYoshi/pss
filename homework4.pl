%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search                                %
% M. Gattinger, previous work by U. Endriss and B. Afshari  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework #4: Solutions                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search                                %
% Homework 3                                                %
% Name: Yoshi Fu                                            %
% Group: J                                                  %
% Email: yoshifu2002@gmail.com                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part A: Insertion Sort                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1: insert/3                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Insert an item into a sorted list and keep it sorted.
 */
% Just add the item if the sorted list is empty.
insert(Item, [], [Item]) :- !.
% If Item < Head, then it is sorted.
insert(Item, [Head | Tail], [Item, Head | Tail]) :-
    Item < Head, !.
% Otherwise, continue through the tail to find the correct place.
insert(Item, [Head | Tail], [Head | Result]) :-
    insert(Item, Tail, Result).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2: insertsort/2                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Sort a list by sorting the tail and then adding an item to
 * the sorted tail.
 */
% An empty list is already sorted and is a sublist of any other list.
insertsort([], []).
% Any list can be sorted by sorting the tail and adding the head with insert/3.
insertsort([Head | Tail], Result) :-
    insertsort(Tail, SortedTail),
    insert(Head, SortedTail, Result).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part B: Labyrinth                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% First, here is the sample grid shown in the homework PDF:

grid([ [w, w, w, b, w],
       [b ,b, w, w, w],
       [w, w, w, b, w],
       [w, b, b, b, b],
       [w, w, w, w, w] ]).

% You can replace it with another grid for local testing, but
% when you upload to CodeGrade please use the original 5x5.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3: white/1                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Check if a square is white in the grid.
 */
white(X/Y) :-
    grid(Grid),  % Get the grid.
    nth1(Y, Grid, Row),  % Get the yth row in the grid.
    nth1(X, Row, Cell),  % Get the xth cell in the row.
    Cell = w.  % Check if the cell is white.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4: move/2                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Check the possible valid moves.
 * A player can only move 1 space left, right, down or up.
 * For all cases, we compute the new coordinates and check if it is white.
 */
move(X/Y, NextState) :-
    NewX is X-1,
    NextState = NewX/Y,
    white(NextState).
move(X/Y, NextState) :-
    NewX is X+1,
    NextState = NewX/Y,
    white(NextState).
move(X/Y, NextState) :-
    NewY is Y-1,
    NextState = X/NewY,
    white(NextState).
move(X/Y, NextState) :-
    NewY is Y+1,
    NextState = X/NewY,
    white(NextState).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5: goal/1                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Check if coordinate X/Y is the goal in the grid.
 *
 * The goal is in the bottom right corner, which is the last row and the last
 * column.
 */
goal(X/Y) :-
    grid([Head | Tail]),
    length([Head | Tail], Y),
    length(Head, X).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6: comparing DFS algorithms                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

depthfirst(Node, []) :-
    goal(Node).
    depthfirst(Node, [NextNode|Path]) :-
    move(Node, NextNode),
    depthfirst(NextNode, Path).

solve_depthfirst(Node, [Node|Path]) :-
    depthfirst(Node, Path).

move_cyclefree(Visited, Node, NextNode) :-
    move(Node, NextNode),
    \+ member(NextNode, Visited).

depthfirst_cyclefree(Visited, Node, Visited) :-
    goal(Node).

depthfirst_cyclefree(Visited, Node, Path) :-
    move_cyclefree(Visited, Node, NextNode),
    depthfirst_cyclefree([NextNode|Visited], NextNode, Path).

solve_depthfirst_cyclefree(Node, Path) :-
    depthfirst_cyclefree([Node], Node, RevPath),
    reverse(RevPath, Path).

depthfirst_bound(_, Visited, Node, Visited) :-
    goal(Node).

depthfirst_bound(Bound, Visited, Node, Path) :-
    Bound > 0,
    move_cyclefree(Visited, Node, NextNode),
    NewBound is Bound - 1,
    depthfirst_bound(NewBound, [NextNode|Visited], NextNode, Path).

solve_depthfirst_bound(Bound, Node, Path) :-
    depthfirst_bound(Bound, [Node], Node, RevPath),
    reverse(RevPath, Path).

/*
plain depthfirst example
?- solve_depthfirst(1/1, Path).
Error: Stack limit (1.0Gb) exceeded
...  % remainder of error message skipped.

The DFS algorithm does not work due to an infinite loop. The algorithms's first
move is to move to the right (1/1 -> 1/2). Since move/2 checks for the cell on
the left first, the move after walks to the left again (1/2 -> 1/1). This means
that the algorithm is caught in a infinite loop with the path:
[1/1, 1/2, 1/1, 1/2, ...].

?- solve_depthfirst_cyclefree(1/1, Path).
Path = [1/1, 2/1, 3/1, 3/2, 3/3, 2/3, 1/3, 1/4, 1/5, 2/5, 3/5, 4/5, 5/5] ;
false.

The DFS cyclefree algorithm finds all paths that reach the goal and do not
contain any cycles. This can solve the maze as arriving at the same cell again
does not give you new options to move to. Therefore, removing the cycles only
removes irrelevent paths.

?- solve_depthfirst_bound(12, 1/1, Path).
Path = [1/1, 2/1, 3/1, 3/2, 3/3, 2/3, 1/3, 1/4, 1/5, 2/5, 3/5, 4/5, 5/5] ;
false.

The DFS bound algorithm finds all paths that have a length of Bound and reach
the goal. Since the Bound used is greater than or equal to 12 a path could be
found, 12 being the length of the shortest path from start to goal in this
particular maze.

? Write down which algorithm you recommend for this problem, and why.
The plain DFS algorithm should not be used as it loops indefinitely on cycles.
The DFS bound algorithm may be used if you want to find the shortest path and
the length of the shortest path is already known. In this case, the algorithm
efficiently searches for the shortest path through the maze and ignores paths
that are longer. If there is no information available on the shortest path of
the maze, then the DFS cyclefree algorithm should be used. The algorithm will
find any possible path through the maze. This guarantees finding any possible
path through the maze, while using a too small bounding parameter would cause
the DFS bound algorithm to not find any solutions.
Therefore, the DFS cyclefree algorithm is recommended for this problem. There
is an exception when there is information about the maze. In that case, using
the DFS bound algorithm may save computing power.
*/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bonus Question 7: animate                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Replace an element at index with value. The index counter starts at 1.
 *
 * The element at index Index is found by getting the head of the list and
 * decremening Index. When Index = 1, the element at Index is found.
 */
% Replace the first element with Value.
replace1([_ | List], 1, Value, [Value | List]) :- !.
% Otherwise, iterate through list until and decrement Index until Index = 1.
replace1([Head | List], Index, Value, [Head | NewList]) :-
    NextIndex is Index - 1,
    replace1(List, NextIndex, Value, NewList).

/**
 * Edit the cell with coordinates X/Y in the Grid to be Value set the result
 * to NewGrid.
 */
editgrid(Grid, X/Y, Value, NewGrid) :-
    nth1(Y, Grid, Row),  % Find the row of the cell to replace.
    replace1(Row, X, Value, NewRow),  % Replace the row with its new cell at index.
    replace1(Grid, Y, NewRow, NewGrid).  % Replace the grid with its new row at index.

/**
 * Write the grid to stdout in a way that is readable for humans.
 */
writegrid([]).
writegrid([Head | Tail]) :-
    write(Head),
    nl,
    writegrid(Tail).

/**
 * Repeat a certain action Goal N amount of times.
 */
repeat(_, 0) :- !.
repeat(Goal, N) :-
    call(Goal),
    N1 is N - 1,
    repeat(Goal, N1).

/**
 * Animate a Path taken through the maze by replacing the cell in the grid at
 * X/Y with p (for Player). Write this new grid to stdout and after sleeping
 * for a bit, write the next move.
 */
animate([]) :- !.
animate([Head | Tail]) :-
    grid(Grid),
    editgrid(Grid, Head, p, PlayerGrid),  % Edit Grid to contain the player.
    repeat(nl, 30),  % Wipe the board.
    writegrid(PlayerGrid),  % Show a frame of the animation.
    sleep(1),  % Wait a bit so humans can see the frame.
    animate(Tail).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declaration
%
% I hereby declare that these solutions are entirely my own work and no part has been copied from other sources.
%
% Number of LC hours I attended this week: 4
%
% Additional hours I spent on the homework: 2
