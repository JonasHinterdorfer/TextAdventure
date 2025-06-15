% ========== MOVEMENT ==========
move_player(Direction) :-
    player_location(CurrentLoc),
    connected(CurrentLoc, Direction),
    (obstacle(CurrentLoc, Direction, ObstacleType) ->
        handle_obstacle(ObstacleType, Direction) ;
        (retract(player_location(CurrentLoc)),
         assertz(player_location(Direction)),
         write('Du gehst nach '), write(Direction), nl
        )),
    !.

move_player(_) :-
    write('Du kannst nicht dorthin gehen.'), nl.

% ========== LOOKING ==========
look_around :-
    player_location(Loc),
    location(Loc, Name, Desc),
    write(Name), nl,
    write(Desc), nl,
    list_items_here(Loc),
    list_npcs_here(Loc),
    list_enemies_here(Loc),
    list_exits(Loc),
    list_obstacles_here(Loc).

list_items_here(Loc) :-
    findall(Item, item_location(Item, Loc), Items),
    (Items = [] -> true ; 
     (write('Gegenstände hier: '), write_list(Items), nl)).

list_npcs_here(Loc) :-
    findall(NPC, npc_location(NPC, Loc), NPCs),
    (NPCs = [] -> true ; 
     (write('Personen hier: '), write_list(NPCs), nl)).

list_enemies_here(Loc) :-
    findall(Enemy, enemy_location(Enemy, Loc), Enemies),
    (Enemies = [] -> true ; 
     (write('Feinde hier: '), write_list(Enemies), nl)).

list_exits(Loc) :-
    findall(Exit, connected(Loc, Exit), Exits),
    (Exits = [] -> write('Keine Ausgänge.') ; 
     (write('Ausgänge: '), write_list(Exits))), nl.

list_obstacles_here(Loc) :-
    findall(obstacle(Loc, Exit, ObstacleType), obstacle(Loc, Exit, ObstacleType), Obstacles),
    (Obstacles = [] -> true ; list_obstacles(Obstacles)).

% ========== HELP ========== 
help :- write('Verfügbare Befehle:'), nl,
    write('- schaue: Beschreibung des aktuellen Ortes'), nl,
    write('- gehe(richtung): Bewege dich zu einem anderen Ort'), nl,
    write('- nimm(gegenstand): Nimm einen Gegenstand auf'), nl,
    write('- verwende(gegenstand): Verwende einen Gegenstand'), nl,
    write('- rede(person): Spreche mit einer Person'), nl,
    write('- angriff(feind): Beginne Kampf gegen einen Feind'), nl,
    write('- baue(item): Baue einen Gegenstand (nur in Werkstatt)'), nl,
    write('- hack(ziel): Hacke ein Ziel'), nl,
    write('- klettere: Klettere auf Dächer/Türme'), nl,
    write('- inventar: Zeige dein Inventar'), nl,
    write('- status: Zeige deinen Status'), nl,
    write('- beende: Schließt das Spiel'), nl,
    write('- clear: Löscht den Terminalbildschirm'), nl, 
    write('- Richtungsbefehle: oben, unten, links, rechts, a, b'), nl,
    write('  (Könnte für etwas Besonderes nützlich sein...)'), nl.