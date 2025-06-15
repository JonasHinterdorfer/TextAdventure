% ========== UTILITY PREDICATES ==========
get_random_damage(Damage) :-
    random(12, 21, Damage).  % Random damage between 12-20

get_random_enemy_damage(Damage) :-
    random(10, 19, Damage).  % Random enemy damage between 10-18

damage_player(Damage) :-
    player_health(Health),
    NewHealth is Health - Damage,
    retract(player_health(Health)),
    assertz(player_health(NewHealth)).

random_member(Element, List) :-
    length(List, Length),
    Length > 0,
    random(0, Length, RandomIndex),
    nth0(RandomIndex, List, Element).

write_list([]).
write_list([H|T]) :-
    write(H),
    (T = [] -> true ; write(', ')),
    write_list(T).

write_sequence([]).
write_sequence([H|T]) :-
    write(H),
    (T = [] -> true ; write(' -> ')),
    write_sequence(T).

read_sequence(Sequence) :-
    read(Input),
    (is_list(Input) ->
        Sequence = Input ;
        Sequence = [Input]).

clear_screen :-
    catch(shell('clear'), _, (catch(shell('cls'), _, fail))).