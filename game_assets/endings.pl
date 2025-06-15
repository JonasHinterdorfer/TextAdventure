% ========== FINAL CHOICES ========== 
final_choice :-
    write('=== FINALE ENTSCHEIDUNG ==='), nl,
    write('Du hast drei Möglichkeiten:'), nl,
    write('1) Das Hauptquartier mit einer EMP-Überladung zerstören (du stirbst dabei)'), nl,
    write('2) Dich Aviary Control anschließen und die Welt beherrschen'), nl,
    write('3) Das System hacken und die Kontrolle übernehmen'), nl,
    write('Deine Wahl (1-3): '),
    read(Choice),
    handle_final_choice(Choice),
    game_over_menu.

handle_final_choice(1) :-
    write('Du entscheidest dich für das ultimative Opfer...'), nl,
    write('Du überlädst alle EMP-Generatoren und Granaten gleichzeitig.'), nl,
    write('Die resultierende Explosion wird das gesamte Aviary-Netzwerk vernichten.'), nl,
    write('Du weißt, dass du dabei sterben wirst, aber die Menschheit wird frei sein.'), nl,
    write('Du drückst den roten Knopf...'), nl,
    end_game(heroic_sacrifice).

handle_final_choice(2) :-
    write('Du blickst auf die Macht, die vor dir liegt...'), nl,
    write('Warum gegen das System kämpfen, wenn du es beherrschen kannst?'), nl,
    write('Du aktivierst die Aviary-Kontrolle und übernimmst das Drohnen-Netzwerk.'), nl,
    write('Die Welt wird unter deiner Herrschaft "sicher" sein...'), nl,
    write('Aber zu welchem Preis?'), nl,
    end_game(dark_ruler).

handle_final_choice(3) :-
    player_inventory(master_schluessel),
    write('Du verwendest den Master-Schlüssel für vollständigen Systemzugriff...'), nl,
    write('Mit diesem legendären Artefakt hackst du dich mühelos durch alle Sicherheitsebenen!'), nl,
    write('Du übernimmst nicht nur die Kontrolle - du wirst zum Meister des Systems!'), nl,
    write('Die Drohnen werden zu Beschützern der Freiheit umfunktioniert.'), nl,
    write('Du etablierst ein neues Zeitalter der technologischen Harmonie!'), nl,
    end_game(master_hacker_victory),
    !.

handle_final_choice(3) :-
    write('Du versuchst das System zu hacken, aber die Sicherheit ist zu stark...'), nl,
    write('Ohne die richtige Ausrüstung ist ein vollständiger Hack unmöglich.'), nl,
    write('Du wirst entdeckt und gefangen genommen!'), nl,
    write('(Hinweis: Es gibt einen geheimen Weg, diese Fähigkeit zu erlangen...)'), nl,
    end_game(hack_failure).

handle_final_choice(_) :-
    write('Ungültige Wahl! Bitte wähle 1, 2 oder 3.'), nl,
    final_choice.

% ========== GAME ENDINGS ==========
end_game(heroic_sacrifice) :-
    clear_screen,
    write('=== HEROISCHES OPFER ==='), nl,
    write('BOOOOOOM!'), nl,
    write('Das Aviary HQ explodiert in einem blendenden Lichtblitz!'), nl,
    write('Alle Drohnen weltweit fallen gleichzeitig vom Himmel.'), nl,
    write('Die Menschen von Linz und der ganzen Welt sind frei!'), nl,
    write('Du hast dein Leben für die Freiheit der Menschheit geopfert.'), nl,
    write('Du wirst als Held in Erinnerung bleiben!'), nl,
    write('ENDE: Der ultimative Held'), nl.

end_game(dark_ruler) :-
    clear_screen,
    write('=== DUNKLER HERRSCHER ==='), nl,
    write('Die Drohnen schwärmen aus und überwachen jeden Winkel der Erde.'), nl,
    write('Unter deiner Kontrolle gibt es keine Verbrechen, keine Unordnung...'), nl,
    write('Aber auch keine Freiheit, keine Privatsphäre, keine Menschlichkeit.'), nl,
    write('Du sitzt auf einem Thron aus Überwachung und Kontrolle.'), nl,
    write('Die Welt ist "sicher" - aber zu welchem Preis?'), nl,
    write('ENDE: Der neue Überwacher'), nl.

end_game(master_hacker_victory) :-
    clear_screen,
    write('=== MEISTER-HACKER TRIUMPH ==='), nl,
    write('Mit dem Master-Schlüssel hast du göttliche Kontrolle über das Netzwerk erlangt!'), nl,
    write('Du transformierst das gesamte System in einen Beschützer der Menschheit.'), nl,
    write('Die Drohnen werden zu Helfern: Sie retten Menschen, schützen die Umwelt'), nl,
    write('und überwachen nur noch wirkliche Bedrohungen.'), nl,
    write('Du hast die perfekte Balance zwischen Sicherheit und Freiheit geschaffen!'), nl,
    write('Die Welt ist in eine neue Ära des technologischen Friedens eingetreten.'), nl,
    write('ENDE: Der Meister-Hacker (Geheimes Ende)'), nl.

end_game(hack_failure) :-
    clear_screen,
    write('=== HACK FEHLGESCHLAGEN ==='), nl,
    write('Deine Hacking-Versuche wurden entdeckt!'), nl,
    write('Sicherheitsdrohnen umzingeln dich!'), nl,
    write('Du wurdest gefangen genommen und das System läuft weiter...'), nl,
    write('GAME OVER'), nl,
    write('Vielleicht gibt es einen anderen Weg... einen geheimen Code?'), nl.

end_game(defeat) :-
    clear_screen,
    write('=== NIEDERLAGE ==='), nl,
    write('Du wurdest von den Drohnen überwältigt.'), nl,
    write('Die Wahrheit bleibt für immer begraben...'), nl,
    write('GAME OVER'), nl,
    game_over_menu.


% ========== GAME_OVER MENU ==========
game_over_menu :-
    nl,
    write('=== SPIEL BEENDET ==='), nl,
    write('Möchtest du nochmal spielen?'), nl,
    write('1) Ja - Neues Spiel starten'), nl,
    write('2) Nein - Program beenden'), nl,
    write('Deine Wahl (1 oder 2): '),
    read(Choice),
    handle_game_over_choice(Choice).

handle_game_over_choice(1) :-
    nl,
    write('Startet neues Spiel...'), nl,
    nl,
    start_game.

handle_game_over_choice(2) :-
    end_game.

handle_game_over_choice(_) :-
    write('Ungültige Wahl! Bitte wähle 1, 2 oder 3.'), nl,
    game_over_menu.