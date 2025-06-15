% ========== CHARACTERS ==========
character(john, 'John Miller', 'Ein 17-jähriger HTL-Schüler mit Hacking-Fähigkeiten.').
character(wren, 'Wren', 'Cybersicherheitslehrerin und Rogue-Hackerin.').
character(die_kraehe, 'Die Krähe', 'KI-Mastermind hinter dem Drohnen-Netzwerk.').

% Initial NPC locations
init_npcs :-
    retractall(npc_location(_, _)),
    assertz(npc_location(wren, htl_labor)).

% ========== ENEMIES ==========
init_enemies :-
    retractall(enemy(_, _, _, _)),
    retractall(enemy_location(_, _)),
    assertz(enemy(tauben_schwarm, 'Tauben-Schwarm', 50, 'Metallische Tauben mit roten LED-Augen.')),
    assertz(enemy(storch_drohne, 'Storch-Drohne', 80, 'Große, gepanzerte Kampfdrohne.')),
    assertz(enemy(die_kraehe, 'Die Krähe', 150, 'Monströse KI-Drohne mit Gedankenkontrolle.')),
   
    assertz(enemy_location(tauben_schwarm, altstadt)),
    assertz(enemy_location(storch_drohne, donauufer)),
    assertz(enemy_location(die_kraehe, aviary_hq)).