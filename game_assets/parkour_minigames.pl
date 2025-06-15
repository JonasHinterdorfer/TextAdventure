% ========== PARKOUR-MINIGAMES ==========
parkour_minigame_altstadt :-
    write('Sequenz-Challenge: Wiederhole die Bewegungsfolge!'), nl,
    random_member(Sequence, [[sprung, rolle, kletter], [rolle, sprung, balance], [kletter, sprung, rolle]]),
    write('Merke dir: '), write_sequence(Sequence), nl,
    write('Warte...'), nl, sleep(2),
    clear_screen,
    write('Jetzt wiederhole die Sequenz:'), nl,
    write('Gib die Sequenz als Liste ein, z.B. [sprung, rolle, kletter].'), nl,
    write('Verfügbare Bewegungen: sprung, rolle, kletter, balance'), nl,
    write('> '),
    read_sequence(UserSequence),
    (UserSequence = Sequence ->
        (write('Perfekte Ausführung! Du erreichst das Dach sicher!'), nl,
         write('Du findest eine verschlossene Box auf dem Dach.'), nl,
         write('Verwende "hack(box)" um sie zu öffnen.'), nl) ;
        (write('Falsche Sequenz! Du rutschst ab und verlierst 10 Gesundheit.'), nl,
         damage_player(10))).

climbing_minigame_donauufer :-
    write('Balance-Challenge: Halte das Gleichgewicht!'), nl,
    write('Drücke abwechselnd "links" und "rechts" um das Gleichgewicht zu halten.'), nl,
    write('Du musst 5 mal korrekt reagieren!'), nl,
    balance_challenge(5, 0).

balance_challenge(0, Success) :-
    Success >= 4,
    write('Excellent! Du hast den Turm erfolgreich erklommen!'), nl,
    write('Oben ist ein elektrisches Schutzschild um eine Box.'), nl,
    write('Du brauchst eine EMP-Granate um das Schild zu deaktivieren.'), nl,
    (player_inventory(emp_granate) ->
        (write('Du verwendest die EMP-Granate! Das Schild fällt aus!'), nl,
         retract(player_inventory(emp_granate)),
         write('Verwende "hack(box)" um die Box zu öffnen.'), nl) ;
        true),
    !.

balance_challenge(0, Success) :-
    Success < 4,
    write('Du verlierst das Gleichgewicht und fällst! 15 Schaden!'), nl,
    damage_player(15),
    !.

balance_challenge(Remaining, Success) :-
    Remaining > 0,
    random_member(Direction, [links, rechts]),
    write('Das Gebäude schwankt nach '), write(Direction), write('! Schnell reagieren:'), nl,
    write('> '),
    read(Response),
    NewRemaining is Remaining - 1,
    (Response = Direction ->
        (write('Gut! Gleichgewicht gehalten.'), nl,
         NewSuccess is Success + 1) ;
        (write('Falsch! Du wackelst gefährlich.'), nl,
         NewSuccess = Success)),
    balance_challenge(NewRemaining, NewSuccess).

climbing_minigame_poestlingberg :-
    write('Stealth-Klettern: Vermeide die Überwachungskameras!'), nl,
    write('Du musst die richtige Route wählen um unentdeckt zu bleiben.'), nl,
    stealth_climbing_challenge.

stealth_climbing_challenge :-
    write('Stufe 1: Kamera schwenkt von links nach rechts. Wann bewegst du dich?'), nl,
    write('1) Wenn die Kamera nach links schaut'), nl,
    write('2) Wenn die Kamera nach rechts schaut'), nl,
    write('3) Wenn die Kamera geradeaus schaut'), nl,
    write('> '),
    read(Choice1),
    (Choice1 = 1 ->
        (write('Richtig! Du nutzt den toten Winkel.'), nl,
         write('Stufe 2: Zwei Kameras kreuzen sich. Wann bewegst du dich?'), nl,
         write('1) Gleichzeitig mit beiden'), nl,
         write('2) Zwischen den Schwenkbewegungen'), nl,
         write('3) Wenn eine Kamera defekt ist'), nl,
         write('> '),
         read(Choice2),
         (Choice2 = 2 ->
             (write('Perfekt! Du erreichst die Spitze unentdeckt!'), nl,
              write('Du findest eine schwer gesicherte Box.'), nl,
              write('Diese Box benötigt eine Kampfdrohne zum Hacken.'), nl) ;
             (write('Entdeckt! Alarm! Du verlierst 20 Gesundheit beim hastigen Rückzug.'), nl,
              damage_player(20)))) ;
        (write('Entdeckt! Du musst schnell fliehen und verlierst 15 Gesundheit.'), nl,
         damage_player(15))).