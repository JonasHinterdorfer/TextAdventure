% ========== CRAFTING SYSTEM ==========
craft_item(emp_generator) :-
    player_location(htl_werkstatt),
    player_inventory(spule),
    player_inventory(batterie),
    player_inventory(kondensator),
    write('Du baust aus Spule, Batterie und Kondensator einen EMP-Generator!'), nl,
    retract(player_inventory(spule)),
    retract(player_inventory(batterie)),
    retract(player_inventory(kondensator)),
    assertz(player_inventory(emp_generator)),
    retract(game_state(emp_built, false)),
    assertz(game_state(emp_built, true)),
    !.

craft_item(emp_generator) :-
    player_location(htl_werkstatt),
    write('Du brauchst: Elektro-Spule, Hochleistungsbatterie und Kondensator.'), nl,
    !.

craft_item(emp_generator) :-
    write('Du kannst nur in der HTL Leonding Werkstatt bauen.'), nl,
    !.

craft_item(kampfdrohne) :-
    player_location(htl_werkstatt),
    player_inventory(drohnen_motor),
    player_inventory(steuerungsmodul),
    write('Du baust aus Motor und Steuerungsmodul eine Kampfdrohne!'), nl,
    retract(player_inventory(drohnen_motor)),
    retract(player_inventory(steuerungsmodul)),
    assertz(player_inventory(kampfdrohne)),
    !.

craft_item(kampfdrohne) :-
    player_location(htl_werkstatt),
    write('Du brauchst: Drohnen-Motor und Steuerungsmodul um eine Kampfdrohne zu bauen.'), nl,
    !.

craft_item(kampfdrohne) :-
    write('Du kannst nur in der HTL Leonding Werkstatt bauen.'), nl,
    !.

craft_item(_) :-
    write('Du kannst diesen Gegenstand nicht bauen.'), nl.