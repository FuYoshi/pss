%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search
% Homework 4
% Name: ...
% Group: ...
% Email: ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part A: The Game of Nim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 1: representation and example/1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2: terminal/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3: lower/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 4: move/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5: first move for three heaps with 3,5,7 matches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6: which version is faster?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part B: Counting Rollouts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 7: rollout/3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 8: count/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 9: Rollouts for the Game of Nim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (a)
% ...

% (b)
% ...

% (c)
% ...

% (d)
% ...







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
