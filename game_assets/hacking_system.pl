% ========== HACKING SYSTEM ==========
hack_target(box) :-
    player_location(Loc),
    player_inventory(laptop),
    hacking_minigame(Loc),
    !.
 
hack_target(_) :-
    write('Du kannst dieses Ziel nicht hacken oder hast keinen Laptop.'), nl.

% ========== HACKING MINI-GAMES ==========
hacking_minigame(altstadt) :-
    box_unlocked(altstadt_box),
    write('Diese Box wurde bereits gehackt.'), nl,
    !.

hacking_minigame(altstadt) :-
    write('=== HACKING MINI-GAME ==='), nl,
    write('Entschlüssele den Code: 1001 + 0110 = ?'), nl,
    write('Gib das Ergebnis in binär ein: '),
    read(Answer),
    (Answer = 1111 ->
        (write('Korrekt! Du findest eine Elektro-Spule in der Box!'), nl,
         assertz(player_inventory(spule)),
         assertz(box_unlocked(altstadt_box))) ;
        (write('Falsch! Versuch es nochmal.'), nl,
         fail)).

hacking_minigame(donauufer) :-
    box_unlocked(donauufer_box),
    write('Diese Box wurde bereits gehackt.'), nl,
    !.

hacking_minigame(donauufer) :-
    write('=== HACKING MINI-GAME ==='), nl,
    write('SQL Injection: Welcher Befehl umgeht die Passwort-Abfrage?'), nl,
    write('1) DROP TABLE users'), nl,
    write('2) \' OR \'1\'=\'1'), nl,
    write('3) SELECT * FROM passwords'), nl,
    write('Deine Wahl (1-3): '),
    read(Answer),
    (Answer = 2 ->
        (write('Korrekt! Du findest eine Hochleistungsbatterie in der Box!'), nl,
         assertz(player_inventory(batterie)),
         assertz(box_unlocked(donauufer_box))) ;
        (write('Falsch! Versuch es nochmal.'), nl,
         fail)).

hacking_minigame(poestlingberg) :-
    box_unlocked(poestlingberg_box),
    write('Diese Box wurde bereits gehackt.'), nl,
    !.

hacking_minigame(poestlingberg) :-
    player_inventory(kampfdrohne),
    write('=== DROHNEN-HACKING ==='), nl,
    write('Deine Kampfdrohne verbindet sich mit der Box...'), nl,
    write('Netzwerk-Port-Scan: Welcher Port ist für SSH Standard?'), nl,
    write('1) Port 80'), nl,
    write('2) Port 22'), nl,
    write('3) Port 443'), nl,
    write('Deine Wahl (1-3): '),
    read(Answer),
    (Answer = 2 ->
        (write('Korrekt! Du findest einen Kondensator in der Box!'), nl,
         assertz(player_inventory(kondensator)),
         assertz(box_unlocked(poestlingberg_box))) ;
        (write('Falsch! Versuch es nochmal.'), nl,
         fail)).

hacking_minigame(poestlingberg) :-
    write('Du brauchst eine Kampfdrohne um diese Box zu hacken.'), nl.

hacking_minigame(_) :-
    write('Hier gibt es nichts zu hacken.'), nl.