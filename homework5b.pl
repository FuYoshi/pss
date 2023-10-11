%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem Solving and Search
% Name: Yoshi Fu
% Group: J
% Email: yoshifu2002@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework #5 Part B: Route Planning with A*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5: data about cities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Distances (https://www.openstreetmap.org/)
distance(amsterdam, utrecht, 45).
distance(amsterdam, haarlem, 29).
distance(amsterdam, zwolle, 105).
distance(amsterdam, rotterdam, 77).
distance(groningen, leeuwarden, 64).
distance(groningen, utrecht, 188). % ?
distance(groningen, zwolle, 105).
distance(leeuwarden, utrecht, 162). % ?
distance(leeuwarden, haarlem, 139).
distance(leeuwarden, zwolle, 97).
distance(utrecht, breda, 74).
distance(utrecht, haarlem, 59).
distance(utrecht, zwolle, 91).
distance(utrecht, hertogenbosch, 56).
distance(utrecht, rotterdam, 58).
distance(breda, eindhoven, 64).
distance(breda, hertogenbosch, 52).
distance(breda, rotterdam, 48).
distance(haarlem, rotterdam, 73).
distance(maastricht, zwolle, 175). % ?
distance(maastricht, eindhoven, 87).
distance(zwolle, eindhoven, 152). % ?
distance(zwolle, hertogenbosch, 132).
distance(eindhoven, hertogenbosch, 34).
distance(hertogenbosch, rotterdam, 81).

% Coordinates (Latitude/Longitude) (https://www.openstreetmap.org/)
coordinate(amsterdam, 52.3731/4.8925).
coordinate(groningen, 53.2191/6.5680).
coordinate(leeuwarden, 53.201/5.792).
coordinate(utrecht, 52.0907/5.1216).
coordinate(breda, 51.5888/4.7760).
coordinate(haarlem, 52.384/4.644).
coordinate(maastricht, 50.858/5.697).
coordinate(zwolle, 52.5150/6.0980).
coordinate(eindhoven, 51.4393/5.4786).
coordinate(hertogenbosch, 51.6889/5.3031).
coordinate(rotterdam, 51.9244/4.4778).

/**
 * Compute the coordinates of a city in km.
 *
 * Source:
 * https://stackoverflow.com/questions/1253499/simple-calculations-for-working-with-lat-lon-and-km-distance#:~:text=The%20approximate%20conversions%20are%3A,111.320*cos(latitude)%20km
 */
coordinates(City, X/Y) :-
	coordinate(City, Latitude/Longitude),
	X is Latitude * 110.574,
	Y is Longitude * (111.320 * cos(Latitude * 3.14159 / 180)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6: move/3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 7: estimate/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pythagoras(A, B, C) :-
	C is sqrt(A * A + B * B).

estimate(Src/Dst, Estimate) :-
	coordinates(Src, X0/Y0),
	coordinates(Dst, X1/Y1),
	DX is abs(X1 - X0),
	DY is abs(Y1 - Y0),
	pythagoras(DX, DY, Estimate).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 8: route/4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 9: examples with first three answers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bonus Question 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ...





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A* Implementation from the Slides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This part of the program provides the implementations of
% the A* algorithm for heuristic-guided best-first search
% introduced in class. See Lecture 10 for explanations.
% Do not modify this code and do not write comments for it.

solve_astar(Node, Path/Cost) :-
  estimate(Node, Estimate),
  astar([[Node]/0/Estimate], RevPath/Cost/_),
  reverse(RevPath, Path).

astar(Paths, Path) :-
  get_best(Paths, Path),
  Path = [Node|_]/_/_,
  goal(Node).

astar(Paths, SolutionPath) :-
  get_best(Paths, BestPath),
  select(BestPath, Paths, OtherPaths),
  expand_astar(BestPath, ExpPaths),
  append(OtherPaths, ExpPaths, NewPaths),
  astar(NewPaths, SolutionPath).

get_best([Path], Path) :- !.

get_best([Path1/Cost1/Est1,_/Cost2/Est2|Paths], BestPath) :-
  Cost1 + Est1 =< Cost2 + Est2, !,
  get_best([Path1/Cost1/Est1|Paths], BestPath).

get_best([_|Paths], BestPath) :-
  get_best(Paths, BestPath).

expand_astar(Path, ExpPaths) :-
  findall(NewPath, move_astar(Path,NewPath), ExpPaths).

move_astar([Node|Path]/Cost/_, [NextNode,Node|Path]/NewCost/Estimate) :-
  move(Node, NextNode, StepCost),
  \+ member(NextNode, Path),
  NewCost is Cost + StepCost,
  estimate(NextNode, Estimate).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declaration
%
% I hereby declare that these solutions are entirely my own work and no part has been copied from other sources.
%
% Number of LC hours I attended this week: 4
%
% Additional hours I spent on the homework: 2
