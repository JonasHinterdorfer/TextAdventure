% ========== CLIMBING SYSTEM ==========
climb_action :-
    player_location(altstadt),
    player_inventory(parkour_handschuhe),
    write('=== PARKOUR KLETTERN ==='), nl,
    write('Du beginnst den Aufstieg...'), nl,
    parkour_minigame_altstadt,
    !.

climb_action :-
    player_location(altstadt),
    write('Du brauchst Parkour-Handschuhe um auf das Dach zu klettern.'), nl,
    !.

climb_action :-
  player_location(donauufer),
  player_inventory(parkour_handschuhe),
  write('=== TURM KLETTERN ==='), nl,
  write('Du kletterst den hohen Industrieturm hinauf...'), nl,
  climbing_minigame_donauufer,
  !.

climb_action :-
    player_location(donauufer),
    write('Du brauchst Parkour-Handschuhe um auf den Turm zu klettern.'), nl,
    !.

climb_action :-
    player_location(poestlingberg),
    player_inventory(parkour_handschuhe),
    write('=== ÜBERWACHUNGSTURM KLETTERN ==='), nl,
    write('Du kletterst den gefährlichen Überwachungsturm hinauf...'), nl,
    climbing_minigame_poestlingberg,
    !.

climb_action :-
    player_location(poestlingberg),
    write('Du brauchst Parkour-Handschuhe um auf den Überwachungsturm zu klettern.'), nl,
    !.
  
climb_action :-
    write('Hier gibt es nichts zum Klettern.'), nl.