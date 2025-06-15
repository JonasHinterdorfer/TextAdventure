% ========== KONAMI CODE ==========
check_konami_input(Input) :-
    (konami_position(_) -> true ; init_konami),
    konami_position(Pos),
    konami_sequence(Sequence),
    nth0(Pos, Sequence, Expected),
    (Input = Expected ->
        (NewPos is Pos + 1,
         retract(konami_position(Pos)),
         assertz(konami_position(NewPos)),
         length(Sequence, SeqLength),
         (NewPos >= SeqLength ->
            unlock_konami_code ;
            true)) ;
        (retract(konami_position(_)),
         assertz(konami_position(0)),
         write('Invalide Code, Hinweis: Contra.'), nl)).

init_konami :-
    retractall(konami_sequence(_)),
    retractall(konami_position(_)),
    assertz(konami_sequence([oben, oben, unten, unten, links, rechts, links, rechts, b, a])),
    assertz(konami_position(0)).

unlock_konami_code :-
    game_state(konami_unlocked, false),
    write('*** KONAMI CODE AKTIVIERT! ***'), nl,
    write('Ein geheimnisvoller Master-Schlüssel materialisiert sich in deinem Inventar!'), nl,
    write('Dieses Artefakt gewährt dir vollständigen Zugriff auf alle Systeme...'), nl,
    assertz(player_inventory(master_schluessel)),
    retract(game_state(konami_unlocked, false)),
    assertz(game_state(konami_unlocked, true)),
    retract(konami_position(_)),
    assertz(konami_position(0)),
    !.

unlock_konami_code :-
    write('Der Konami Code wurde bereits aktiviert!'), nl,
    retract(konami_position(_)),
    assertz(konami_position(0)).