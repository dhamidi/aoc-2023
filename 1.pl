:- set_prolog_flag(double_quotes, chars).
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

main(1-1, Answer) :-
  with_input('1.txt', calibration_instructions(ListOfDigits, numeric)),
  maplist(calibration_digits_number, ListOfDigits, Numbers),
  sum_list(Numbers, Answer).

main(1-2, Answer) :-
  with_input('1.txt', calibration_instructions(ListOfDigits, alpha)),
  maplist(calibration_digits_number, ListOfDigits, Numbers),
  sum_list(Numbers, Answer).

test(1-2, Answer) :-
  Input = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
twone
",
  string_chars(Input, Chars),
  phrase(calibration_instructions(ListOfDigits, alpha), Chars),
  maplist(calibration_digits_number, ListOfDigits, Numbers),
  sum_list(Numbers, Answer),
  Answer =:= 281 + 21.

with_input(File, Goal) :-
  read_file_to_string(File, S, []),
  string_chars(S, Chars),
  phrase(Goal, Chars).


calibration_digits_number(D, N) :-
  nth1(1, D, First),
  length(D, Length),
  nth1(Length, D, Last),
  number_string(N, [First, Last]).


calibration_instructions([I|Is], Mode) --> calibration_digits(I, Mode), !, calibration_instructions(Is, Mode).
calibration_instructions([], _) --> [].

calibration_digits([D|Ds], Mode) --> calibration_digit(D, Mode), !, calibration_digits(Ds, Mode).
calibration_digits([], _) --> "\n", !.
calibration_digits(Ds, Mode) --> [_], calibration_digits(Ds, Mode).

calibration_digit(D, _) --> [D], { char_type(D, digit) }.
calibration_digit('9', alpha), "ine" --> "nine".
calibration_digit('8', alpha), "ight" --> "eight".
calibration_digit('7', alpha), "even" --> "seven".
calibration_digit('6', alpha), "ix" --> "six".
calibration_digit('5', alpha), "ive" --> "five".
calibration_digit('4', alpha), "our" --> "four".
calibration_digit('3', alpha), "hree" --> "three".
calibration_digit('2', alpha), "wo" --> "two".
calibration_digit('1', alpha), "ne" --> "one".
