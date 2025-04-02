% SkyNet: Wings of Deception - Prolog Implementation

% Charaktere
charakter(user, skynet_agent).
charakter(wren, cybersecurity_lehrer).
charakter(havik, cybernetic_enforcer).
charakter(the_crow, ki_mastermind).

% Fähigkeiten der Charaktere
faehigkeit(user, hacking).
faehigkeit(user, parkour).
faehigkeit(user, combat_drone).
faehigkeit(wren, remote_sabotage).
faehigkeit(wren, emp_crafting).
faehigkeit(wren, information_brokering).
faehigkeit(havik, combat_mastery).
faehigkeit(havik, drone_swarm_control).
faehigkeit(havik, interrogation).
faehigkeit(the_crow, mind_control).
faehigkeit(the_crow, hive_coordination).
faehigkeit(the_crow, cloaking).

% Feinde
feind(pigeon, basic).
feind(stork, heavy).
feind(the_crow, boss).

% Fähigkeiten der Feinde
feind_faehigkeit(pigeon, swarming).
feind_faehigkeit(pigeon, pecking).
feind_faehigkeit(stork, tactical_strike).
feind_faehigkeit(stork, armor_plating).
feind_faehigkeit(the_crow, hive_control).
feind_faehigkeit(the_crow, psychic_scramble).
feind_faehigkeit(the_crow, shadow_phase).

% Schwächen der Feinde
schwaeche(pigeon, loud_noise).
schwaeche(pigeon, fragile).
schwaeche(stork, langsam).
schwaeche(the_crow, emp).

% Orte im Spiel
ort(schule).
ort(strasse).
ort(aviary_hq).
ort(geheimes_labor).
ort(dachboden_aviary_hq).

% Verbindungen zwischen Orten
verbindung(strasse, schule).
verbindung(schule, strasse).
verbindung(strasse, geheimes_labor).
verbindung(geheimes_labor, strasse).
verbindung(geheimes_labor, aviary_hq).
verbindung(aviary_hq, geheimes_labor).
verbindung(aviary_hq, dachboden_aviary_hq).
verbindung(dachboden_aviary_hq, aviary_hq).

% Gegenstände im Spiel
gegenstand(emp_grenade).
gegenstand(hacking_tool).
gegenstand(signal_jammer).

% Wo Gegenstände gefunden werden können
gegenstand_ort(emp_grenade, stork).  % Storks droppen EMP Granaten
gegenstand_ort(hacking_tool, schule).
gegenstand_ort(signal_jammer, geheimes_labor).

% Story-Meilensteine
story_milestone(1, "Überlebt einen Vogel-Angriff auf dem Weg zur Schule").
story_milestone(2, "Entdeckt in der Cybersecurity-Klasse, dass Vögel bewaffnete Überwachungsdrohnen sind").
story_milestone(3, "Spricht mit Wren über die Aviary Control-Gruppe").
story_milestone(4, "Übersteht den ersten Kampf gegen einen Taubenschwarm").
story_milestone(5, "Wird von Agent HAVIK nach einem wichtigen Fund überfallen").
story_milestone(6, "Trifft auf schwer gepanzerte Storch-Drohnen").
story_milestone(7, "Bemerkt, dass Zivilisten seltsam handeln - The Crow's Gedankenkontrolle breitet sich aus").
story_milestone(8, "Baut mit Wren einen EMP, um den Schwarm zu stören").
story_milestone(9, "Kämpft den finalen Kampf auf dem Dach des Aviary HQ").
story_milestone(10, "Entscheidet, ob die Wahrheit aufgedeckt wird oder ob man ein weiteres Opfer wird").

% Spielzustand
:- dynamic(aktueller_ort/1).
:- dynamic(inventar/1).
:- dynamic(abgeschlossene_meilensteine/1).
:- dynamic(feind_besiegt/1).

initialisiere_spiel :-
    % Überprüfen, ob dynamic deklariert wurde
    (predicate_property(aktueller_ort(_), dynamic) -> 
        true 
    ; 
        dynamic(aktueller_ort/1),
        dynamic(inventar/1),
        dynamic(abgeschlossene_meilensteine/1),
        dynamic(feind_besiegt/1)
    ),
    % Bisherige Werte löschen
    retractall(aktueller_ort(_)),
    retractall(inventar(_)),
    retractall(abgeschlossene_meilensteine(_)),
    retractall(feind_besiegt(_)),
    % Neue Werte setzen
    assertz(aktueller_ort(strasse)),
    assertz(abgeschlossene_meilensteine(0)),
    write('SkyNet: Wings of Deception - Das Abenteuer beginnt!'), nl,
    write('Du überlebst knapp einen "Vogel-Angriff" auf dem Weg zur Schule.'), nl,
    write('Was möchtest du tun? (gehe_zu(Ort), untersuche, kaempfe, inventar, hilfe)'), nl.

% Bewegung zwischen Orten
gehe_zu(Ziel) :-
    aktueller_ort(Aktuelle),
    verbindung(Aktuelle, Ziel),
    retractall(aktueller_ort(_)),
    assertz(aktueller_ort(Ziel)),
    beschreibe_ort(Ziel),
    pruefe_story_fortschritt,
    !.

gehe_zu(Ziel) :-
    aktueller_ort(Aktuelle),
    \+ verbindung(Aktuelle, Ziel),
    write('Du kannst von hier aus nicht direkt dorthin gelangen.'), nl.

% Beschreibungen der Orte
beschreibe_ort(schule) :-
    write('Du befindest dich in der Schule. Der Cybersecurity-Unterricht findet im Raum 101 statt.'), nl,
    write('Wren, dein Lehrer, scheint nervös zu sein und wirft immer wieder Blicke aus dem Fenster.'), nl.

beschreibe_ort(strasse) :-
    write('Du bist auf der Straße. Mehrere Tauben sitzen auf den Stromkabeln und scheinen dich zu beobachten.'), nl,
    write('Ein unheimliches Gefühl überkommt dich - ihre Bewegungen wirken mechanisch.'), nl.

beschreibe_ort(geheimes_labor) :-
    write('Du hast Wrens geheimes Labor gefunden. Überall liegen Elektronikteile und Drohnenreste herum.'), nl,
    write('An der Wand hängt eine Karte mit markierten Orten - einer davon ist das Aviary HQ.'), nl.

beschreibe_ort(aviary_hq) :-
    write('Das imposante Aviary HQ-Gebäude ragt vor dir auf. Die Sicherheitsmaßnahmen sind streng.'), nl,
    write('Storch-Drohnen patrouillieren den Eingang und Scanner überwachen jeden Winkel.'), nl.

beschreibe_ort(dachboden_aviary_hq) :-
    write('Du stehst auf dem Dach des Aviary HQ. Der Wind peitscht dir ins Gesicht.'), nl,
    write('In der Mitte des Daches steht eine massive schwarze Gestalt - The Crow, der Mastermind hinter allem.'), nl.

% Kampfsystem
kaempfe :-
    aktueller_ort(strasse),
    \+ feind_besiegt(pigeon),
    write('Du wirst von einem Schwarm Tauben angegriffen!'), nl,
    write('Mit deinen Kampfdrohnen kannst du sie abwehren. Die Tauben explodieren bei Treffern und beschädigen andere in der Nähe.'), nl,
    write('Nach einem intensiven Kampf hast du die Drohnen besiegt.'), nl,
    assertz(feind_besiegt(pigeon)),
    pruefe_story_fortschritt,
    !.

kaempfe :-
    aktueller_ort(aviary_hq),
    \+ feind_besiegt(stork),
    write('Schwer gepanzerte Storch-Drohnen greifen dich an!'), nl,
    write('Sie sind langsam, aber ihre Panzerung macht sie widerstandsfähig. Sie führen Sturzflug-Angriffe aus!'), nl,
    inventar(hacking_tool),
    write('Mit deinem Hacking-Tool kannst du ihre Systeme kurzzeitig stören und sie besiegen.'), nl,
    write('Nach dem Kampf findest du eine EMP-Granate.'), nl,
    assertz(inventar(emp_grenade)),
    assertz(feind_besiegt(stork)),
    pruefe_story_fortschritt,
    !.

kaempfe :-
    aktueller_ort(dachboden_aviary_hq),
    \+ feind_besiegt(the_crow),
    inventar(emp_grenade),
    inventar(signal_jammer),
    write('The Crow greift dich mit voller Macht an! Seine Fähigkeiten zur Gedankenkontrolle und Tarnung machen ihn zu einem gefährlichen Gegner.'), nl,
    write('Mit der EMP-Granate und dem Signal-Jammer kannst du seine Kontrolle über den Schwarm unterbrechen und ihn verwundbar machen.'), nl,
    write('Nach einem epischen Kampf gelingt es dir, The Crow zu besiegen und seine Pläne zu durchkreuzen.'), nl,
    assertz(feind_besiegt(the_crow)),
    pruefe_story_fortschritt,
    !.

kaempfe :-
    aktueller_ort(dachboden_aviary_hq),
    \+ feind_besiegt(the_crow),
    write('The Crow ist zu mächtig ohne die richtigen Werkzeuge. Du brauchst einen EMP und einen Signal-Jammer, um eine Chance zu haben!'), nl,
    !.

kaempfe :-
    write('Es gibt hier nichts zu bekämpfen.'), nl.

% Untersuchung der Umgebung
untersuche :-
    aktueller_ort(schule),
    \+ inventar(hacking_tool),
    write('Du durchsuchst den Computerraum und findest ein spezielles Hacking-Tool, das Wren zurückgelassen hat.'), nl,
    write('Es könnte nützlich sein, um die Drohnen zu hacken.'), nl,
    assertz(inventar(hacking_tool)),
    pruefe_story_fortschritt,
    !.

untersuche :-
    aktueller_ort(geheimes_labor),
    \+ inventar(signal_jammer),
    write('Bei genauerer Untersuchung von Wrens Labor findest du einen Signal-Jammer.'), nl,
    write('Er scheint speziell für die Frequenzen der Vogel-Drohnen entwickelt worden zu sein.'), nl,
    assertz(inventar(signal_jammer)),
    pruefe_story_fortschritt,
    !.

untersuche :-
    aktueller_ort(Ort),
    write('Du untersuchst die Umgebung, findest aber nichts Besonderes.'), nl.

% Inventar anzeigen
inventar :-
    findall(Item, inventar(Item), Items),
    write('Dein Inventar enthält:'), nl,
    liste_items(Items).

liste_items([]) :-
    write('- Nichts'), nl.
liste_items([Item|Rest]) :-
    write('- '), write(Item), nl,
    liste_items(Rest).

% Story-Fortschritt überprüfen
pruefe_story_fortschritt :-
    abgeschlossene_meilensteine(Aktuell),
    NaechsterMeilenstein is Aktuell + 1,
    pruefe_meilenstein(NaechsterMeilenstein),
    retractall(abgeschlossene_meilensteine(_)),
    assertz(abgeschlossene_meilensteine(NaechsterMeilenstein)),
    story_milestone(NaechsterMeilenstein, Beschreibung),
    write('*** STORY-FORTSCHRITT: '), write(Beschreibung), write(' ***'), nl,
    !.

pruefe_story_fortschritt.

% Bedingungen für Meilensteine
pruefe_meilenstein(1) :-
    aktueller_ort(strasse).
pruefe_meilenstein(2) :-
    aktueller_ort(schule).
pruefe_meilenstein(3) :-
    aktueller_ort(schule),
    inventar(hacking_tool).
pruefe_meilenstein(4) :-
    feind_besiegt(pigeon).
pruefe_meilenstein(5) :-
    aktueller_ort(geheimes_labor).
pruefe_meilenstein(6) :-
    aktueller_ort(aviary_hq).
pruefe_meilenstein(7) :-
    feind_besiegt(stork).
pruefe_meilenstein(8) :-
    inventar(emp_grenade),
    inventar(signal_jammer).
pruefe_meilenstein(9) :-
    aktueller_ort(dachboden_aviary_hq).
pruefe_meilenstein(10) :-
    feind_besiegt(the_crow).

% Hilfe anzeigen
hilfe :-
    write('Verfügbare Befehle:'), nl,
    write('- start. : Spiel initialisieren'), nl,
    write('- gehe_zu(Ort). : Zu einem anderen Ort gehen'), nl,
    write('- untersuche. : Die Umgebung untersuchen'), nl,
    write('- kaempfe. : Gegen Feinde kämpfen'), nl,
    write('- inventar. : Inventar anzeigen'), nl,
    write('- hilfe. : Diese Hilfe anzeigen'), nl,
    write('- beende_spiel. : Das Spiel beenden'), nl,
    write('Verfügbare Orte: schule, strasse, geheimes_labor, aviary_hq, dachboden_aviary_hq'), nl,
    write('WICHTIG: Vergiss nicht, einen Punkt nach jedem Befehl zu setzen!'), nl.

% Aktuellen Spielstand anzeigen
status :-
    aktueller_ort(Ort),
    abgeschlossene_meilensteine(Meilenstein),
    write('Du befindest dich hier: '), write(Ort), nl,
    write('Story-Fortschritt: Meilenstein '), write(Meilenstein), write(' abgeschlossen'), nl,
    write('Verfügbare Verbindungen:'), nl,
    findall(Ziel, verbindung(Ort, Ziel), Ziele),
    liste_orte(Ziele).

liste_orte([]) :-
    write('- Keine verfügbaren Verbindungen'), nl.
liste_orte([Ort|Rest]) :-
    write('- '), write(Ort), nl,
    liste_orte(Rest).

% Spiel beenden
beende_spiel :-
    write('Danke fürs Spielen von SkyNet: Wings of Deception!'), nl,
    halt.

% Hauptprädikat zum Starten des Spiels
start :- 
    initialisiere_spiel,
    write('Spiel gestartet. Vergiss nicht, einen Punkt nach jedem Befehl zu setzen!'), nl.
