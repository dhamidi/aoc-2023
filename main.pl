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
