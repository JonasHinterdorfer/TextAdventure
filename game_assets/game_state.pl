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

% ========== GAME STATE MANAGEMENT ==========
check_game_state :-
    player_health(Health),
    (Health =< 0 -> 
        (retractall(in_combat(_)), 
         end_game(defeat),
         !, fail) ; 
        true).

show_status :-
    player_health(Health),
    write('=== STATUS ==='), nl,
    write('Gesundheit: '), write(Health), nl,
    (player_inventory(kampfdrohne) ->
        write('Kampfdrohne: ✓ Gebaut'), nl ;
        (write('Kampfdrohne Komponenten:'), nl,
         (player_inventory(drohnen_motor) -> write('  Drohnen-Motor: ✓') ; write('  Drohnen-Motor: ✗')), nl,
         (player_inventory(steuerungsmodul) -> write('  Steuerungsmodul: ✓') ; write('  Steuerungsmodul: ✗')), nl)),
    (game_state(emp_built, true) ->
        write('EMP-Generator: ✓ Gebaut'), nl ;
        (write('EMP-Generator Komponenten:'), nl,
         (player_inventory(spule) -> write('  Elektro-Spule: ✓') ; write('  Elektro-Spule: ✗')), nl,
         (player_inventory(batterie) -> write('  Batterie: ✓') ; write('  Batterie: ✗')), nl,
         (player_inventory(kondensator) -> write('  Kondensator: ✓') ; write('  Kondensator: ✗')), nl)),
    write('=============='), nl.