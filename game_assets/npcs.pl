% ========== CHARACTERS ==========
character(john, 'John Miller', 'Ein 17-jähriger HTL-Schüler mit Hacking-Fähigkeiten.').
character(wren, 'Wren', 'Cybersicherheitslehrerin und Rogue-Hackerin.').
character(die_kraehe, 'Die Krähe', 'KI-Mastermind hinter dem Drohnen-Netzwerk.').

% ========== INITIAL NPC LOCATIONS ==========
init_npcs :-
    retractall(npc_location(_, _)),
    assertz(npc_location(wren, htl_labor)).


% ========== NPC INTERACTIONS ==========
talk_to(PersonName) :-
    player_location(Loc),
    npc_location(PersonName, Loc),
    handle_conversation(PersonName),
    !.

talk_to(_) :-
    write('Diese Person ist nicht hier.'), nl.

handle_conversation(wren) :-
    game_state(wren_met, false),
    write('Wren: "John! Ich habe auf dich gewartet. Ich weiß von den Drohnen."'), nl,
    write('Wren: "Es gibt eine Organisation namens Aviary Control. Wir müssen sie stoppen!"'), nl,
    write('Wren: "Du brauchst einen EMP-Generator um in ihr Hauptquartier einzudringen."'), nl,
    write('Wren: "Sammle diese Komponenten: Elektro-Spule, Hochleistungsbatterie und Kondensator."'), nl,
    write('Wren: "Die Spule findest du in einer Box auf einem Dach in der Altstadt."'), nl,
    write('Wren: "Die Batterie ist in einer Box auf einem Turm im Donauufer versteckt."'), nl,
    write('Wren: "Der Kondensator ist im Pöstlingberg-Turm, aber du brauchst eine Kampfdrohne."'), nl,
    write('Wren: "Baue deine eigene Kampfdrohne! Besiege Tauben für einen Motor und Störche für Steuerung."'), nl,
    write('Wren: "Baue alles dann in der HTL Leonding Werkstatt zusammen."'), nl,
    write('Wren gibt dir EMP-Granaten für den Anfang.'), nl,
    assertz(player_inventory(emp_granate)),
    assertz(player_inventory(emp_granate)),
    retract(game_state(wren_met, false)),
    assertz(game_state(wren_met, true)),
    retract(game_state(components_explained, false)),
    assertz(game_state(components_explained, true)),
    advance_chapter_if(1),
    !.

handle_conversation(wren) :-
    game_state(components_explained, true),
    game_state(emp_built, false),
    write('Wren: "Vergiss nicht: Du brauchst alle drei Komponenten für den EMP-Generator!"'), nl,
    write('Wren: "Elektro-Spule (Altstadt-Dach), Batterie (Donauufer-Turm), Kondensator (Pöstlingberg)."'), nl,
    write('Wren: "Verwende Parkour-Handschuhe zum Klettern und deine Kampfdrohne im Pöstlingberg."'), nl,
    !.

handle_conversation(wren) :-
    game_state(emp_built, true),
    write('Wren: "Perfekt! Mit dem EMP-Generator kannst du ins Aviary HQ eindringen!"'), nl,
    write('Wren: "Pass auf die Krähe auf - schwäche sie mit EMP-Granaten, sonst kontrolliert sie dich!"'), nl,
    advance_chapter_if(4),
    !.

handle_conversation(wren) :-
    write('Wren: "Viel Glück, John. Die Zukunft der Menschheit liegt in deinen Händen."'), nl.

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

handle_enemy_defeat(tauben_schwarm) :-
    write('Die Tauben explodieren! Du findest ein Heilspray und einen Drohnen-Motor in den Trümmern.'), nl,
    player_location(Loc),
    assertz(item_location(drohnen_motor, Loc)),
    assertz(item_location(heilspray, Loc)).

handle_enemy_defeat(storch_drohne) :-
    write('Die Storch-Drohne lässt ein Steuerungsmodul und EMP-Granaten fallen!'), nl,
    player_location(Loc),
    assertz(item_location(steuerungsmodul, Loc)),
    assertz(item_location(emp_granate, Loc)).

handle_enemy_defeat(die_kraehe) :-
    write('Die Krähe ist besiegt! Das Drohnen-Netzwerk wankt...'), nl,
    write('Du stehst vor der Hauptkonsole von Aviary Control.'), nl,
    write('Plötzlich erscheint eine Nachricht auf dem Bildschirm:'), nl,
    write('"Beeindruckend, John. Du hast es bis hierher geschafft."'), nl,
    write('"Aber jetzt musst du eine Wahl treffen..."'), nl,
    final_choice.