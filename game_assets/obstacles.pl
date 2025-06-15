% ========== OBSTACLES ==========
init_obstacles :-
    % Obstacle between altstadt and donauufer
    assertz(obstacle(altstadt, donauufer, hohe_mauer)),
    assertz(obstacle(donauufer, altstadt, hohe_mauer)),
    
    % Obstacle between donauufer and poestlingberg  
    assertz(obstacle(donauufer, poestlingberg, drone_swarm)),
    assertz(obstacle(poestlingberg, donauufer, drone_swarm)),
    
    % Obstacle to aviary_hq
    assertz(obstacle(poestlingberg, aviary_hq, security_system)),
    assertz(obstacle(aviary_hq, poestlingberg, security_system)).

describe_obstacle(hohe_mauer) :-
    write('Hohe Mauer - benötigt Parkour-Handschuhe zum Klettern').
describe_obstacle(drone_swarm) :-
    write('Drohnen-Schwarm - benötigt Kampfdrohne zur Abwehr').
describe_obstacle(security_system) :-
    write('Hochsicherheitssystem - benötigt EMP-Generator').

list_obstacles([]).
list_obstacles([obstacle(_, Exit, ObstacleType)|T]) :-
    write('HINDERNIS nach '), write(Exit), write(': '), 
    describe_obstacle(ObstacleType), nl,
    list_obstacles(T).

handle_obstacle(hohe_mauer, Direction) :-
    (player_inventory(parkour_handschuhe) ->
        (write('Du kletterst mit den Parkour-Handschuhen über die hohe Mauer!'), nl,
         player_location(CurrentLoc),
         retract(obstacle(CurrentLoc, Direction, hohe_mauer)),
         retract(player_location(CurrentLoc)),
         assertz(player_location(Direction)),
         write('Du gehst nach '), write(Direction), nl) ;
        write('Eine hohe Mauer blockiert deinen Weg! Du brauchst Parkour-Handschuhe.'), nl).

handle_obstacle(drone_swarm, Direction) :-
    (player_inventory(kampfdrohne) ->
        (write('Deine Kampfdrohne bekämpft den feindlichen Schwarm!'), nl,
         write('Die Drohnen werden zerstört und der Weg ist frei!'), nl,
         player_location(CurrentLoc),
         retract(obstacle(CurrentLoc, Direction, drone_swarm)),
         retract(player_location(CurrentLoc)),
         assertz(player_location(Direction)),
         write('Du gehst nach '), write(Direction), nl) ;
        write('Ein Schwarm aggressiver Drohnen blockiert den Weg! Du brauchst eine Kampfdrohne.'), nl).

handle_obstacle(security_system, Direction) :-
    (player_inventory(emp_generator) ->
        (write('Du aktivierst den EMP-Generator! Das Sicherheitssystem bricht zusammen!'), nl,
         player_location(CurrentLoc),
         retract(obstacle(CurrentLoc, Direction, security_system)),
         retract(player_location(CurrentLoc)),
         assertz(player_location(Direction)),
         write('Du gehst nach '), write(Direction), nl) ;
        write('Ein Hochsicherheitssystem blockiert den Zugang! Du brauchst einen EMP-Generator.'), nl).