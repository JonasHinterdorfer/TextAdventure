% ========== INPUT PROCESSING ==========
read_line(Command) :-
    read(Input),
    parse_input(Input, Command).

parse_input(Input, [Input]) :-
    atom(Input), !.

parse_input(Input, Command) :-
    compound(Input),
    Input =.. Command, !.

parse_input(_, [unknown]).

% ========== COMMAND PROCESSING ==========
process_command([oben]) :- check_konami_input(oben).
process_command([unten]) :- check_konami_input(unten).
process_command([links]) :- check_konami_input(links).
process_command([rechts]) :- check_konami_input(rechts).
process_command([a]) :- check_konami_input(a).
process_command([b]) :- check_konami_input(b).

process_command([beende]) :-
    end_game.

process_command([hilfe]) :-
    help.

process_command([schaue]) :-
    look_around.

process_command([gehe, Direction]) :-
    move_player(Direction).

process_command([nimm, Item]) :-
    take_item(Item).

process_command([verwende, Item]) :-
    use_item(Item).

process_command([rede, Person]) :-
    talk_to(Person).

process_command([angriff, Enemy]) :-
    start_combat(Enemy).

process_command([baue, Item]) :-
    craft_item(Item).

process_command([hack, Target]) :-
    hack_target(Target).

process_command([klettere]) :-
    climb_action.

process_command([inventar]) :-
    show_inventory.

process_command([status]) :-
    show_status.

process_command([clear]) :-
    clear_screen.

% ========== CHEAT CODES (FOR TESTING) ==========
process_command([cheat, heal]) :-
    retract(player_health(_)),
    assertz(player_health(100)),
    write('Gesundheit wiederhergestellt!'), nl.

process_command([cheat, items]) :-
    assertz(player_inventory(spule)),
    assertz(player_inventory(batterie)),
    assertz(player_inventory(kondensator)),
    assertz(player_inventory(emp_granate)),
    assertz(player_inventory(emp_granate)),
    assertz(player_inventory(parkour_handschuhe)),
    assertz(player_inventory(drohnen_motor)),
    assertz(player_inventory(steuerungsmodul)),
    assertz(player_inventory(heilspray)),
    write('Alle Items erhalten!'), nl.

process_command([cheat, teleport, LOC]) :-
    retract(player_location(_)),
    assertz(player_location(LOC)).

process_command([cheat, generator_components]) :-
    assertz(player_inventory(spule)),
    assertz(player_inventory(batterie)),
    assertz(player_inventory(kondensator)),
    write('EMP-Generator Komponenten erhalten!'), nl.
  
process_command([cheat, generator_components]) :-
    assertz(player_inventory(drohnen_motor)),
    assertz(player_inventory(steuerungsmodul)),
    write('Kampfdrone Komponenten erhalten!'), nl.

process_command(_) :-
    write('Unbekannter Befehl. Verwende "hilfe" für eine Liste der Befehle.'), nl.