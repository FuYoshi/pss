%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search
% Homework 6
% Name: Yoshi Fu
% Group: J
% Email: yoshifu2002@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part A: The Game of Nim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1: representation and example/1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Description of representation
Each state consists of a board and the player to move.

The Board is a list of numbers that specify the amount of matches in their
heap respectively.

Symbols are not required as the players only remove matches and winning is
dependant on which player removed the final match. This representation can
easily show when matches are removed by lowering the number in the list.
 */

/* Example initial state of Game of Nim with heaps of 3, 4 and 5. */
example(([3, 4, 5], max)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2: terminal/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Give the value for when a player wins. */
value(max, 1).
value(min, -1).

/* Check if a state is terminal and give its value. */
% Base case. The empty list is a subset of every terminal state.
terminal(([], Player), Value) :-
	value(Player, Value).  % OtherPlayer took the last match and Player wins.
% Recursive case. Check if the head is 0, then check the tail.
terminal(([0 | Tail], Player), Value) :-
	terminal((Tail, Player), Value).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3: lower/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Get the positive integers lower than N in ascending order (including 0). */
lower(X, N) :-			% Interface to use the algorithm.
	N > 0,				% Ensure we only have positive integers.
	lower(X, 0, N).
lower(X, X, _).			% Rule that gives an answer.
lower(X, N0, Nk) :-		% Rule that increments the number.
	N1 is N0 + 1,		% Increment the number.
	N1 < Nk,			% Check if it is strictly below the upper bound.
	lower(X, N1, Nk). 	% Continue incrementing.

% /* Get the positive integers lower than N in descending order (including 0). */
% lower(X, N) :-		% Interface to use the algorithm.
% 	N > 0,			    % Ensure we only have positive integers.
% 	N1 is N - 1,		% Compute the starting number.
% 	lower(X, N1, 0).
% lower(X, X, _).		% Rule that gives an answer.
% lower(X, N0, Nk) :-	% Rule that decrements the number.
% 	N1 is N0 - 1,		% Decrement the number.
% 	N1 >= Nk,			% Check if it is above the lower bound.
% 	lower(X, N1, Nk).   % Continue decrementing.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4: move/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Get the other player. */
other(max, min).
other(min, max).

/* Remove matches from a heap in the Game of Nim. */
move((Board, Player), (NewBoard, OtherPlayer)) :-
	append(LeftHeaps, [Heap | RightHeaps], Board),  	  % Pick a heap.
	lower(NewHeap, Heap), 								  % Determine X.
	append(LeftHeaps, [NewHeap | RightHeaps], NewBoard),  % Remove X matches.
	other(Player, OtherPlayer). 						  % Switch players.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5: first move for three heaps with 3,5,7 matches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Query used:
?- alphabeta(([3, 5, 7], max), MaxState).

Recommended Move:
MaxState =  ([2, 5, 7], min)
 */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6: which version is faster?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- time(alphabeta(([3, 5, 7], max), MaxState)).

ascending result:
3,173,855 inferences, 0.266 CPU in 0.266 seconds (100% CPU, 11917637 Lips)

descending result:
49,891,735 inferences, 3.856 CPU in 3.857 seconds (100% CPU, 12937980 Lips)

The ascending version of lower/2 is faster. This is because the ascending
version removes more matches per move and reaches a terminal state faster.
Any state that the ascending version reaches, is reached by the descending
version in more steps. This means that the ascending version considers later
stages of the game before the descending version reaches such state.
 */


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part B: Counting Rollouts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 7: rollout/3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Perform moves from an initial state until it reaches a terminal state.
 * Set Result to be the state of the final board and Value to be the value.
 */
% Base case (1). Check if a terminal state is reached.
rollout(State, State, Value) :-
	terminal(State, Value).
% Base case (2). Given a state, find all next states and check their rollouts.
rollout(State, Result, Value) :-
	moves(State, NextStates),
	rollouts(NextStates, Result, Value).
% Recursive case (1). Rollout the head of the list of states.
rollouts([State | _], Result, Value) :-
	rollout(State, Result, Value).
% Recursive case (2). Rollout the tail of the list of states.
rollouts([_ | OtherStates], Result, Value) :-
	rollouts(OtherStates, Result, Value).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 8: count/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
 * Count the number of games Games a goal Goal is satisfied.
 */
count(Goal, Games) :-
	findall(_, Goal, Bag),  % Find all possible ways to complete goal.
	length(Bag, Games).     % Count the games where the goal is satisfied.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 9: Rollouts for the Game of Nim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (a)
/*
?- State = ([1,1,1,1,1], max), Goal = rollout(State,_,_), count(Goal, Games).
Games = 120.
 */

% (b)
/*
?- State = ([5], max), Goal = rollout(State,_,_), count(Goal, Games).
Games = 16.
 */

% (c)
/*
?- State = ([2,2,2,2,2], max), Goal = rollout(State,_,_), count(Goal, Games).
Games = 291720
 */

% (d)
/*
?- State = ([5,5], max), Goal = rollout(State,_,_), count(Goal, Games).
Games = 6802
 */






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Minimax with Alpha-Beta Pruning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Do not modify this code.

% Return all follow-up states for a given state:

moves(State, NextStates) :-
  findall(NextState, move(State, NextState), NextStates).

% Choose whether to bind the variable provided as the fourth
% argument to either the term given as the second argument
% (if the goal provided as the first argument succeeds) or
% the term given as the third argument argument (otherwise):

choose(Condition, X, _, X) :- call(Condition), !.
choose(_, _, Y, Y).

% Given numbers X, A, and B with A  =< B, find the number
% closest to X within the interval [A, B]:

round(X, A, _, A) :- X < A, !.
round(X, _, B, B) :- X > B, !.
round(X, _, _, X).

% Predicate alphabeta(+State, -BestNextState)

alphabeta((Board,max), MaxState) :-
  moves((Board,max), NextStates),
  maxeval(NextStates, -1, +1, MaxState, _).

alphabeta((Board,min), MinState) :-
  moves((Board,min), NextStates),
  mineval(NextStates, -1, +1, MinState, _).

% Predicate eval(+State, +Alpha, +Beta, -Value)

eval(_, Value, Value, Value) :- !.

eval(State, Alpha, Beta, RoundedValue) :-
  terminal(State, Value), !,
  round(Value, Alpha, Beta, RoundedValue).

eval((Board,max), Alpha, Beta, Value) :-
  moves((Board,max), NextStates),
  maxeval(NextStates, Alpha, Beta, _, Value).

eval((Board,min), Alpha, Beta, Value) :-
  moves((Board,min), NextStates),
  mineval(NextStates, Alpha, Beta, _, Value).

% Predicate maxeval(+States, +Alpha, +Beta, -MaxState, -MaxValue)

maxeval([State], Alpha, Beta, State, Value) :- !,
  eval(State, Alpha, Beta, Value).

maxeval([State1|States], Alpha, Beta, MaxState, MaxValue) :-
  eval(State1, Alpha, Beta, Value1),
  maxeval(States, Value1, Beta, State, Value),
  choose(Value > Value1, (State,Value), (State1,Value1), (MaxState,MaxValue)).

% Predicate mineval(+States, +Alpha, +Beta, -MinState, -MinValue)

mineval([State], Alpha, Beta, State, Value) :- !,
  eval(State, Alpha, Beta, Value).

mineval([State1|States], Alpha, Beta, MinState, MinValue) :-
  eval(State1, Alpha, Beta, Value1),
  mineval(States, Alpha, Value1, State, Value),
  choose(Value < Value1, (State,Value), (State1,Value1), (MinState,MinValue)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declaration
%
% I hereby declare that these solutions are entirely my own work and no part has been copied from other sources.
%
% Number of LC hours I attended this week: 2
%
% Additional hours I spent on the homework: 4
