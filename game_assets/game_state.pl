% ========== GAME STATE ==========
:- dynamic(player_location/1).
:- dynamic(player_health/1).
:- dynamic(player_inventory/1).
:- dynamic(game_state/2).
:- dynamic(npc_location/2).
:- dynamic(enemy_location/2).
:- dynamic(item_location/2).
:- dynamic(enemy/4).
:- dynamic(enemy_hacked/1).
:- dynamic(hack_attempted/1).
:- dynamic(obstacle/3).
:- dynamic(box_unlocked/1).
:- dynamic(in_combat/1).
:- dynamic(combat_turn/1).
:- dynamic(emp_used_in_combat/1).
:- dynamic(drone_cooldown/2).
:- dynamic(health_recovery_used/2).
:- dynamic(konami_sequence/1).
:- dynamic(konami_position/1).
:- dynamic(chapter/1).

% ========== GAME STATE MANAGEMENT ==========
check_game_state :-
    player_health(Health),
    (Health =< 0 -> 
        (retractall(in_combat(_)), 
         end_game(defeat),
         !, fail) ; 
        true).

advance_chapter :-
    chapter(Current),
    Next is Current + 1,
    retract(chapter(Current)),
    assertz(chapter(Next)).

advance_chapter_if(TargetChapter) :-
    (chapter(TargetChapter) ->
        advance_chapter ;
        true).

% ========== OBJECTIVE DEFINITIONS ==========
objective(0, 'Schaue dir das Video des Angriffs auf deinem Laptop an').
objective(1, 'Sprich mit Wren').
objective(2, 'Sammle alle Teile der Kampfdrohne und baue die in der HTL-Werkstatt zusammen').
objective(3, 'Sammle alle Teile des EMP-Generators und baue der in der HTL-Werkstatt zusammen').
objective(4, 'Sprich mit Wren').
objective(5, 'Besiege die Krähe').


% ========== SHOW STATUS ==========
show_current_objective :-
    chapter(CurrentChapter),
    objective(CurrentChapter, ObjectiveText),
    write('Aktuelles Ziel: '), write(ObjectiveText), nl.

show_required_components :-
    chapter(CurrentChapter),
    % Show drone components only if collecting drone parts (chapter 3)
    (CurrentChapter =:= 2 ->
        (write('Kampfdrohne Komponenten:'), nl,
         (player_inventory(drohnen_motor) -> write('  Drohnen-Motor: ✓') ; write('  Drohnen-Motor: ✗')), nl,
         (player_inventory(steuerungsmodul) -> write('  Steuerungsmodul: ✓') ; write('  Steuerungsmodul: ✗')), nl) ;
        true),
    % Show EMP components only if collecting EMP parts (chapter 5)
    (CurrentChapter =:= 3 ->
        (write('EMP-Generator Komponenten:'), nl,
         (player_inventory(spule) -> write('  Elektro-Spule: ✓') ; write('  Elektro-Spule: ✗')), nl,
         (player_inventory(batterie) -> write('  Batterie: ✓') ; write('  Batterie: ✗')), nl,
         (player_inventory(kondensator) -> write('  Kondensator: ✓') ; write('  Kondensator: ✗')), nl) ;
        true).

show_status :-
    player_health(Health),
    write('=== STATUS ==='), nl,
    write('Gesundheit: '), write(Health), nl,
    show_current_objective,
    show_required_components,
    write('=============='), nl.