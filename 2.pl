:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

main(2-1, Answer) :-
  make,
  with_input('2.txt', games(G)),
  games_scores(G, Scores),
  phrase(count_solutions(Scores), [0], [Answer]), !.

main(2-2, Answer) :-
  make,
  with_input('2.txt', games(G)),
  games_scores(G, Scores),
  phrase(scores_powerset(Scores), [0], [Answer]), !.

with_input(File, Goal) :-
  read_file_to_string(File, S, []),
  string_chars(S, Chars),
  phrase(Goal, Chars).

% part 2
scores_powerset([S|Scores]) --> score_powerset(S), !, scores_powerset(Scores).
scores_powerset([]) --> [].

score_powerset(score(_, R, G, B)), [N] --> [N0], { N #= N0 + R * G * B }.


% part 1
count_solutions([S|Scores]) --> count_solution(S), !, count_solutions(Scores).
count_solutions([]) --> [].

count_solution(score(ID, R, G, B)), [N] --> 
  [N0],
  { R #=< 12 },
  { G #=< 13 },
  { B #=< 14 },
  { N #= N0 + ID }.
count_solution(score(_, _, _, _)), [N] --> [N].

games_scores(Games, Scores) :-
  maplist(game_score, Games, Scores).

% useful in the REPL
example_game(ID-Turns) :-
  Text = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\n",
  phrase(game(ID, Turns), Text).

game_score(ID-Turns, Score) :-
  maplist(turn_to_score, Turns, Scores),
  maplist(score_red, Scores, Reds),
  maplist(score_green, Scores, Greens),
  maplist(score_blue, Scores, Blues),
  max_member(MaxRed, Reds),
  max_member(MaxGreen, Greens),
  max_member(MaxBlue, Blues),
  Score = score(ID, MaxRed, MaxGreen, MaxBlue).

score_red(score(_, Red, _, _), Red).
score_green(score(_, _, Green, _), Green).
score_blue(score(_, _, _, Blue), Blue).

turn_to_score(Turn, Score) :-
  keysort(Turn, Sorted),
  (member(red-Red, Sorted) ; Red = 0),
  (member(green-Green, Sorted); Green = 0),
  (member(blue-Blue, Sorted); Blue = 0),
  Score = score(0, Red, Green, Blue).

turns_to_sums_by_color(Turns, RedSum, GreenSum, BlueSum) :-
  flatten(Turns, Flattened), 
  keysort(Flattened, Sorted),
  group_pairs_by_key(Sorted, Grouped),
  Grouped = [blue-Blue, green-Green, red-Red],
  sum_list(Red, RedSum),
  sum_list(Green, GreenSum),
  sum_list(Blue, BlueSum).

games([Game|Games]) -->
  game(ID, Turns),
  { Game = ID-Turns },
  !,
  games(Games).
games([]) --> [].

game(ID, Turns) -->
  "Game ", integer(ID), ": ",
  turns(Turns).

turns([Turn|Turns]) -->
  draws(Turn),
  blanks,
  ";",
  blanks,
  !,
  turns(Turns).
turns([Turn]) --> draws(Turn), "\n".
turns([]) --> "\n".

draws([Color-N|Draws]) -->
  draw(Color-N),
  blanks,
  ",",
  blanks,
  !,
  draws(Draws).
draws([Draw]) --> draw(Draw).

draw(Color-N) -->
  integer(N),
  " ",
  color(Color).
draw([]) --> [].

color(red) --> "red".
color(green) --> "green".
color(blue) --> "blue".
