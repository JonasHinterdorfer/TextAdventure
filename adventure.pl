% SkyNet: Flügel der Täuschung - Enhanced Version
% Von Zsombor Matyas und Jonas Hinterdorfer

% ========== GAME STATE ==========
:- dynamic(player_location/1).
:- dynamic(player_health/1).
:- dynamic(player_inventory/1).
:- dynamic(game_state/2).
:- dynamic(npc_location/2).
:- dynamic(enemy_location/2).
:- dynamic(item_location/2).
:- dynamic(discovered/1).
:- dynamic(enemy/4).
:- dynamic(enemy_hacked/1).
:- dynamic(hack_attempted/1).
:- dynamic(obstacle/3).
:- dynamic(box_unlocked/1).
:- dynamic(in_combat/1).
:- dynamic(combat_turn/1).
:- dynamic(konami_sequence/1).
:- dynamic(konami_position/1).

% ========== INITIALIZATION ==========
init_game :-
    % Clear any existing state
    retractall(player_location(_)),
    retractall(player_health(_)),
    retractall(game_state(_, _)),
    retractall(obstacle(_, _, _)),
    retractall(box_unlocked(_)),
    retractall(in_combat(_)),
    retractall(combat_turn(_)),
    retractall(enemy_hacked(_)),
    retractall(hack_attempted(_)),
    retractall(crow_weakened(_)),

    % Initialize random number generator
    randomize,
    
    % Set initial game state
    assertz(player_location(htl_labor)),
    assertz(player_health(100)),
    assertz(game_state(wren_met, false)),
    assertz(game_state(emp_built, false)),
    assertz(game_state(crow_weakened, false)),
    assertz(game_state(components_explained, false)),
    assertz(game_state(konami_unlocked, false)),

    % Initialize obstacles
    init_obstacles.

% ========== LOCATIONS ==========
location(htl_labor, 'HTL Cybersicherheitslabor', 
    'Ein modernes Computerlabor mit High-Tech Ausstattung. Hier hast du die Wahrheit über die Drohnen entdeckt.').

location(altstadt, 'Linzer Altstadt',
    'Enge Gassen und alte Gebäude. Perfekt für Parkour, aber voller lauernder Gefahren.').

location(donauufer, 'Donauufer Industriegebiet',
    'Verlassene Fabrikhallen und Lagerhäuser. Schwer bewacht von Storch-Drohnen.').

location(poestlingberg, 'Pöstlingberg Überwachungsturm',
    'Ein alter Turm, umgebaut zur Drohnen-Kommandozentrale. Hier werden alle Signale koordiniert.').

location(aviary_hq, 'Aviary HQ Wolkenkratzer',
    'Das Hauptquartier der Verschwörung. Ein Glasbau, der die ganze Stadt überblickt.').

location(htl_werkstatt, 'HTL Leonding Werkstatt',
    'Eine gut ausgestattete Elektronikwerkstatt. Hier kannst du komplexe Geräte bauen.').

% Location connections
connected(htl_werkstatt, htl_labor).
connected(htl_labor, htl_werkstatt).
connected(htl_labor, altstadt).
connected(altstadt, htl_labor).
connected(altstadt, donauufer).
connected(donauufer, altstadt).
connected(donauufer, poestlingberg).
connected(poestlingberg, donauufer).
connected(poestlingberg, aviary_hq).
connected(aviary_hq, poestlingberg).

% ========== OBSTACLES ==========
init_obstacles :-
    % Obstacle between altstadt and donauufer
    assertz(obstacle(altstadt, donauufer, hohe_mauer)),
    assertz(obstacle(donauufer, altstadt, hohe_mauer)),
    
    % Obstacle between donauufer and poestlingberg  
    assertz(obstacle(donauufer, poestlingberg, drone_swarm)),
    assertz(obstacle(poestlingberg, donauufer, drone_swarm)).
    
    % Obstacle to aviary_hq
    assertz(obstacle(poestlingberg, aviary_hq, security_system)),
    assertz(obstacle(aviary_hq, poestlingberg, security_system)).

% ========== ITEMS ==========
item(laptop, 'Laptop', 'Dein vertrauter Laptop mit Hacking-Software.').
item(emp_granate, 'EMP-Granate', 'Eine elektromagnetische Impulsgranate gegen elektrische Systeme.').
item(parkour_handschuhe, 'Parkour-Handschuhe', 'Verbessern deinen Grip beim Klettern.').
item(kampfdrohne, 'Kampfdrohne', 'Deine selbstgebaute Verteidigungsdrohne.').
item(emp_generator, 'EMP-Generator', 'Ein mächtiger EMP-Generator gegen die Krähe.').
item(coil, 'Elektro-Spule', 'Eine hochwertige Induktionsspule.').
item(battery, 'Hochleistungsbatterie', 'Eine spezielle Batterie für EMP-Geräte.').
item(capacitor, 'Kondensator', 'Ein Hochspannungskondensator.').
item(heilspray, 'Heilspray', 'Regeneriert 30 Gesundheitspunkte.').
item(drohnen_motor, 'Drohnen-Motor', 'Ein kleiner Motor für Drohnen-Antrieb.').
item(steuerungsmodul, 'Steuerungsmodul', 'Elektronisches Modul zur Drohnen-Steuerung.').
item(master_key, 'Master-Schlüssel', 'Ein geheimnisvoller Schlüssel mit Aviary-Logo. Gewährt vollständigen Systemzugriff.').

% Initial item locations
init_items :-
    retractall(item_location(_, _)),
    retractall(player_inventory(_)),
    assertz(player_inventory(laptop)),
    assertz(item_location(parkour_handschuhe, altstadt)),
    assertz(item_location(heilspray, htl_labor)).

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

% ========== MAIN GAME PREDICATES ==========
start_game :-
    init_game,
    init_items,
    init_npcs,
    init_enemies,
    clear_screen,
    write('=== SKYNET: WINGS OF DECEPTION ==='), nl,
    write('Ein Text-Adventure von Jonas Hinterdorfer und Zsombor Matyas'), nl, nl,
    intro_story,
    game_loop.

intro_story :-
    write('Du bist John Miller, 17 Jahre alt und Schüler der HTL Linz.'), nl,
    write('Heute Morgen wurdest du von einem aggressiven Taubenschwarm attackiert.'), nl,
    write('Ihre Augen glühten rot und ihre Bewegungen waren unnatürlich präzise...'), nl,
    write('Jetzt sitzt du im Cybersicherheitslabor und analysierst die Aufnahmen.'), nl, nl,
    write('Für alle verfügbare Befehle schreibe \'hilfe.\''), nl,
    write('Bsp: \'verwende(laptop).\''), nl.

game_loop :-
    (in_combat(Enemy) -> combat_loop(Enemy) ; normal_loop).

normal_loop :-
    player_location(Loc),
    location(Loc, Name, _),
    nl,
    write('Du befindest dich in: '), write(Name), nl,
    write('> '),
    read_line(Command),
    process_command(Command),
    check_game_state,
    !,
    game_loop.

combat_loop(Enemy) :-
    enemy(Enemy, DisplayName, Health, _),
    write('=== KAMPF GEGEN '), write(DisplayName), write(' ==='), nl,
    write('Feind Gesundheit: '), write(Health), nl,
    player_health(PlayerHealth),
    write('Deine Gesundheit: '), write(PlayerHealth), nl,
    write('Verfügbare Aktionen: angriff, verwende(item)'), nl,
    write('> '),
    read_line(Command),
    process_combat_command(Command, Enemy),
    check_combat_state,
    !,
    game_loop.

init_konami :-
    retractall(konami_sequence(_)),
    retractall(konami_position(_)),
    assertz(konami_sequence([oben, oben, unten, unten, links, rechts, links, rechts, b, a])),
    assertz(konami_position(0)).

% ========== INPUT PROCESSING ==========
read_line(Command) :-
    read(Input),
    parse_input(Input, Command).

parse_input(Input, [Input]) :-
    atom(Input), !.

parse_input(Input, Command) :-
    compound(Input),
    Input =.. Command, !.

parse_input(_, [unknown]).

% ========== COMMAND PROCESSING ==========
check_konami_input(Input) :-
    (konami_position(_) -> true ; init_konami),
    konami_position(Pos),
    konami_sequence(Sequence),
    nth0(Pos, Sequence, Expected),
    (Input = Expected ->
        (NewPos is Pos + 1,
         retract(konami_position(Pos)),
         assertz(konami_position(NewPos)),
         length(Sequence, SeqLength),
         (NewPos >= SeqLength ->
            unlock_konami_code ;
            true)) ;
        (retract(konami_position(_)),
         assertz(konami_position(0)),
         write('Ungültige Richtung.'), nl)).

unlock_konami_code :-
    game_state(konami_unlocked, false),
    write('*** KONAMI CODE AKTIVIERT! ***'), nl,
    write('Ein geheimnisvoller Master-Schlüssel materialisiert sich in deinem Inventar!'), nl,
    write('Dieses Artefakt gewährt dir vollständigen Zugriff auf alle Systeme...'), nl,
    assertz(player_inventory(master_key)),
    retract(game_state(konami_unlocked, false)),
    assertz(game_state(konami_unlocked, true)),
    retract(konami_position(_)),
    assertz(konami_position(0)),
    !.

unlock_konami_code :-
    write('Der Konami Code wurde bereits aktiviert!'), nl,
    retract(konami_position(_)),
    assertz(konami_position(0)).

process_command([oben]) :- check_konami_input(oben).
process_command([unten]) :- check_konami_input(unten).
process_command([links]) :- check_konami_input(links).
process_command([rechts]) :- check_konami_input(rechts).
process_command([a]) :- check_konami_input(a).
process_command([b]) :- check_konami_input(b).

process_command([beende]) :-
    write('Auf Wiedersehen! Die Wahrheit muss ans Licht...'), nl,
    halt.

process_command([hilfe]) :-
    write('Verfügbare Befehle:'), nl,
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
    write('- Richtungsbefehle: oben, unten, links, rechts, a, b'), nl,
    write('  (Könnte für etwas Besonderes nützlich sein...)'), nl.

process_command([schaue]) :-
    look_around.

process_command([gehe, Direction]) :-
    move_player(Direction).

process_command([nimm, Item]) :-
    take_item(Item).

process_command([verwende, Item]) :-
    use_item(Item).

process_command([rede, Person]) :-
    talk_to(Person).

process_command([angriff, Enemy]) :-
    start_combat(Enemy).

process_command([baue, Item]) :-
    craft_item(Item).

process_command([hack, Target]) :-
    hack_target(Target).

process_command([klettere]) :-
    climb_action.

process_command([inventar]) :-
    show_inventory.

process_command([status]) :-
    show_status.

process_command([clear]) :-
    clear_screen.

% ========== CHEAT CODES (for testing) ==========
process_command([cheat, heal]) :-
    retract(player_health(_)),
    assertz(player_health(100)),
    write('Gesundheit wiederhergestellt!'), nl.

process_command([cheat, items]) :-
    assertz(player_inventory(coil)),
    assertz(player_inventory(battery)),
    assertz(player_inventory(capacitor)),
    assertz(player_inventory(emp_granate)),
    assertz(player_inventory(emp_granate)),
    assertz(player_inventory(parkour_handschuhe)),
    assertz(player_inventory(drohnen_motor)),
    assertz(player_inventory(steuerungsmodul)),
    assertz(player_inventory(heilspray)),
    write('Alle Items erhalten!'), nl.

process_command([cheat, teleport, LOC]) :-
    retract(player_location(_)),
    assertz(player_location(LOC)).

process_command([cheat, generator_components]) :-
    assertz(player_inventory(coil)),
    assertz(player_inventory(battery)),
    assertz(player_inventory(capacitor)),
    write('EMP-Generator Komponenten erhalten!'), nl.
  
process_command([cheat, generator_components]) :-
    assertz(player_inventory(coil)),
    assertz(player_inventory(battery)),
    assertz(player_inventory(capacitor)),
    write('EMP-Generator Komponenten erhalten!'), nl.

process_command(_) :-
    write('Unbekannter Befehl. Verwende "hilfe" für eine Liste der Befehle.'), nl.

% ========== COMBAT COMMANDS ==========
process_combat_command([angriff], Enemy) :-
    combat_attack(Enemy).

process_combat_command([verwende, Item], Enemy) :-
    combat_use_item(Item, Enemy).

process_combat_command(_, _) :-
    write('Ungültige Kampfaktion! Verwende: angriff oder verwende(item)'), nl.

% ========== CORE GAME MECHANICS ==========
look_around :-
    player_location(Loc),
    location(Loc, Name, Desc),
    write(Name), nl,
    write(Desc), nl,
    list_items_here(Loc),
    list_npcs_here(Loc),
    list_enemies_here(Loc),
    list_exits(Loc),
    check_obstacles_here(Loc).

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

check_obstacles_here(Loc) :-
    findall(obstacle(Loc, Exit, ObstacleType), obstacle(Loc, Exit, ObstacleType), Obstacles),
    (Obstacles = [] -> true ; list_obstacles(Obstacles)).

list_obstacles([]).
list_obstacles([obstacle(_, Exit, ObstacleType)|T]) :-
    write('HINDERNIS nach '), write(Exit), write(': '), 
    describe_obstacle(ObstacleType), nl,
    list_obstacles(T).

describe_obstacle(hohe_mauer) :-
    write('Hohe Mauer - benötigt Parkour-Handschuhe zum Klettern').
describe_obstacle(drone_swarm) :-
    write('Drohnen-Schwarm - benötigt Kampfdrohne zur Abwehr').
describe_obstacle(security_system) :-
    write('Hochsicherheitssystem - benötigt EMP-Generator').

write_list([]).
write_list([H|T]) :-
    write(H),
    (T = [] -> true ; write(', ')),
    write_list(T).

% ========== MOVEMENT WITH OBSTACLES ==========
move_player(Direction) :-
    player_location(CurrentLoc),
    connected(CurrentLoc, Direction),
    (obstacle(CurrentLoc, Direction, ObstacleType) ->
        handle_obstacle(ObstacleType, Direction) ;
        (retract(player_location(CurrentLoc)),
         assertz(player_location(Direction)),
         write('Du gehst nach '), write(Direction), nl,
         trigger_location_event(Direction))),
    !.

move_player(_) :-
    write('Du kannst nicht dorthin gehen.'), nl.


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

% ========== INVENTORY MANAGEMENT ==========
take_item(ItemName) :-
    player_location(Loc),
    item_location(ItemName, Loc),
    retract(item_location(ItemName, Loc)),
    assertz(player_inventory(ItemName)),
    item(ItemName, DisplayName, _),
    write('Du nimmst '), write(DisplayName), write(' auf.'), nl,
    !.

take_item(_) :-
    write('Diesen Gegenstand kannst du hier nicht finden.'), nl.

use_item(ItemName) :-
    player_inventory(ItemName),
    execute_item_use(ItemName),
    !.

use_item(_) :-
    write('Du hast diesen Gegenstand nicht oder kannst ihn nicht verwenden.'), nl.

show_inventory :-
    write('Dein Inventar:'), nl,
    findall(Item, player_inventory(Item), Items),
    (Items = [] -> write('Dein Inventar ist leer.') ; list_inventory_items(Items)), nl.

list_inventory_items([]).
list_inventory_items([H|T]) :-
    item(H, DisplayName, Desc),
    write('- '), write(DisplayName), write(': '), write(Desc), nl,
    list_inventory_items(T).

% ========== ITEM USAGE ==========
execute_item_use(laptop) :-
    player_location(htl_labor),
    write('Du hackst dich in die Schulserver ein und analysierst die Drohnen-Aufnahmen.'), nl,
    write('SCHOCKIERENDE ENTDECKUNG: Die Vögel sind Überwachungsdrohnen!'), nl,
    !.

execute_item_use(heilspray) :-
    player_health(Health),
    (Health >= 100 ->
        write('Du hast bereits volle Gesundheit!'), nl ;
        (NewHealth is min(100, Health + 30),
         retract(player_health(Health)),
         assertz(player_health(NewHealth)),
         write('Du verwendest das Heilspray und gewinnst 30 Gesundheitspunkte!'), nl,
         retract(player_inventory(heilspray)))),
    !.

execute_item_use(_) :-
    write('Du kannst diesen Gegenstand hier nicht verwenden.'), nl.

% ========== TURN-BASED COMBAT SYSTEM ==========
start_combat(EnemyName) :-
    player_location(Loc),
    enemy_location(EnemyName, Loc),
    write('Du beginnst den Kampf gegen '), enemy(EnemyName, DisplayName, _, _),
    write(DisplayName), write('!'), nl,
    assertz(in_combat(EnemyName)),
    !.

start_combat(_) :-
    write('Hier ist kein Feind zum Angreifen.'), nl.

combat_attack(Enemy) :-
    get_random_damage(Damage),
    enemy(Enemy, DisplayName, Health, Desc),
    NewHealth is Health - Damage,
    write('Du greifst '), write(DisplayName), write(' an und verursachst '), 
    write(Damage), write(' Schaden!'), nl,
    retract(enemy(Enemy, DisplayName, Health, Desc)),
    (NewHealth =< 0 ->
        (write(DisplayName), write(' wurde besiegt!'), nl,
         defeat_enemy(Enemy)) ;
        (assertz(enemy(Enemy, DisplayName, NewHealth, Desc)),
         enemy_turn(Enemy))).

combat_use_item(ItemName, Enemy) :-
    player_inventory(ItemName),
    execute_combat_item_use(ItemName, Enemy),
    !.

combat_use_item(_, _) :-
    write('Du hast diesen Gegenstand nicht!'), nl.

execute_combat_item_use(emp_granate, Enemy) :-
    enemy(Enemy, DisplayName, Health, Desc),
    (Enemy = die_kraehe ->
        (write('Du schwächst die Krähe mit der EMP-Granate!'), nl,
         retract(game_state(crow_weakened, false)),
         assertz(game_state(crow_weakened, true)),
         retract(player_inventory(emp_granate))) ;
        (Damage = 40,
         NewHealth is Health - Damage,
         write('Die EMP-Granate verursacht '), write(Damage), write(' Schaden!'), nl,
         retract(enemy(Enemy, DisplayName, Health, Desc)),
         retract(player_inventory(emp_granate)),
         (NewHealth =< 0 ->
            (write(DisplayName), write(' wurde besiegt!'), nl,
             defeat_enemy(Enemy)) ;
            assertz(enemy(Enemy, DisplayName, NewHealth, Desc)),
            enemy_turn(Enemy)))).

execute_combat_item_use(kampfdrohne, Enemy) :-
    enemy(Enemy, DisplayName, Health, Desc),
    Damage = 25,
    NewHealth is Health - Damage,
    write('Deine Kampfdrohne greift an und verursacht '), write(Damage), write(' Schaden!'), nl,
    retract(enemy(Enemy, DisplayName, Health, Desc)),
    (NewHealth =< 0 ->
        (write(DisplayName), write(' wurde besiegt!'), nl,
         defeat_enemy(Enemy)) ;
        assertz(enemy(Enemy, DisplayName, NewHealth, Desc)),
        enemy_turn(Enemy)).

execute_combat_item_use(heilspray, _) :-
    execute_item_use(heilspray).

execute_combat_item_use(Item, _) :-
    write(Item), write('kannst nicht in Kampf verwenden.'), nl.

enemy_turn(Enemy) :-
    enemy(Enemy, DisplayName, _, _),
    (Enemy = die_kraehe, game_state(crow_weakened, false) ->
        crow_mind_control ;
        normal_enemy_attack(Enemy, DisplayName)).

normal_enemy_attack(_, DisplayName) :-
    get_random_enemy_damage(Damage),
    player_health(Health),
    NewHealth is Health - Damage,
    write(DisplayName), write(' greift an und verursacht '), 
    write(Damage), write(' Schaden!'), nl,
    retract(player_health(Health)),
    assertz(player_health(NewHealth)).

crow_mind_control :-
    write('Die Krähe übernimmt die Kontrolle über deinen Verstand!'), nl,
    write('Du schlägst dich selbst!'), nl,
    player_health(Health),
    Damage = 20,
    NewHealth is Health - Damage,
    write('Du verursachst dir '), write(Damage), write(' Schaden!'), nl,
    retract(player_health(Health)),
    assertz(player_health(NewHealth)).

check_combat_state :-
    player_health(Health),
    Health =< 0,
    end_game(defeat).

check_combat_state :-
    player_health(Health),
    Health > 0.

defeat_enemy(EnemyName) :-
    retract(enemy_location(EnemyName, _)),
    retract(in_combat(EnemyName)),
    handle_enemy_defeat(EnemyName).

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


% ========== CRAFTING SYSTEM ==========
craft_item(emp_generator) :-
    player_location(htl_werkstatt),
    player_inventory(coil),
    player_inventory(battery),
    player_inventory(capacitor),
    write('Du baust aus Spule, Batterie und Kondensator einen EMP-Generator!'), nl,
    retract(player_inventory(coil)),
    retract(player_inventory(battery)),
    retract(player_inventory(capacitor)),
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

% ========== HACKING MINI-GAMES ==========
hack_target(box) :-
    player_location(Loc),
    player_inventory(laptop),
    hacking_minigame(Loc),
    !.
 
hack_target(_) :-
    write('Du kannst dieses Ziel nicht hacken oder hast keinen Laptop.'), nl.

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
         assertz(player_inventory(coil)),
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
         assertz(player_inventory(battery)),
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
         assertz(player_inventory(capacitor)),
         assertz(box_unlocked(poestlingberg_box))) ;
        (write('Falsch! Versuch es nochmal.'), nl,
         fail)).

hacking_minigame(poestlingberg) :-
    write('Du brauchst eine Kampfdrohne um diese Box zu hacken.'), nl.

hacking_minigame(_) :-
    write('Hier gibt es nichts zu hacken.'), nl.

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

%Parkour-Migigames
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
         player_health(Health),
         NewHealth is Health - 10,
         retract(player_health(Health)),
         assertz(player_health(NewHealth)))).

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
    player_health(Health),
    NewHealth is Health - 15,
    retract(player_health(Health)),
    assertz(player_health(NewHealth)),
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
    !.

handle_conversation(wren) :-
    write('Wren: "Viel Glück, John. Die Zukunft der Menschheit liegt in deinen Händen."'), nl.

% ========== LOCATION EVENTS ==========
trigger_location_event(donauufer) :-
    enemy_location(storch_drohne, donauufer),
    write('WARNUNG: Eine Storch-Drohne patroulliert hier!'), nl,
    write('Verwende "angriff(storch_drohne)" um den Kampf zu beginnen.'), nl.

trigger_location_event(aviary_hq) :-
    enemy_location(die_kraehe, aviary_hq),
    write('Du betrittst das Hauptquartier von Aviary Control!'), nl,
    write('Die Krähe erwartet dich bereits...'), nl,
    write('WARNUNG: Die Krähe kann dich kontrollieren! Schwäche sie mit EMP-Granaten!'), nl.

trigger_location_event(_).

% ========== GAME STATE MANAGEMENT ==========
check_game_state :-
    player_health(Health),
    (Health =< 0 -> end_game(defeat) ; true).

show_status :-
    player_health(Health),
    write('=== STATUS ==='), nl,
    write('Gesundheit: '), write(Health), nl,
    (player_inventory(kampfdrohne) ->
        write('Kampfdrohne: ✓ Gebaut'), nl ;
        (write('Kampfdrohne Komponenten:'), nl,
         (player_inventory(drohnen_motor) -> write('  Drohnen-Motor: ✓') ; write('  Drohnen-Motor: ✗')), nl,
         (player_inventory(steuerungsmodul) -> write('  Steuerungsmodul: ✓') ; write('  Steuerungsmodul: ✗')), nl)),
    (game_state(emp_built, true) ->
        write('EMP-Generator: ✓ Gebaut'), nl ;
        (write('EMP-Generator Komponenten:'), nl,
         (player_inventory(coil) -> write('  Elektro-Spule: ✓') ; write('  Elektro-Spule: ✗')), nl,
         (player_inventory(battery) -> write('  Batterie: ✓') ; write('  Batterie: ✗')), nl,
         (player_inventory(capacitor) -> write('  Kondensator: ✓') ; write('  Kondensator: ✗')), nl)),
    write('=============='), nl.

% ========== GAME ENDINGS ==========
final_choice :-
    write('=== FINALE ENTSCHEIDUNG ==='), nl,
    write('Du hast drei Möglichkeiten:'), nl,
    write('1) Das Hauptquartier mit einer EMP-Überladung zerstören (du stirbst dabei)'), nl,
    write('2) Dich Aviary Control anschließen und die Welt beherrschen'), nl,
    write('3) Das System hacken und die Kontrolle übernehmen'), nl,
    write('Deine Wahl (1-3): '),
    read(Choice),
    handle_final_choice(Choice).

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
    player_inventory(master_key),
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

end_game(heroic_sacrifice) :-
    clear_screen,
    write('=== HEROISCHES OPFER ==='), nl,
    write('BOOOOOOM!'), nl,
    write('Das Aviary HQ explodiert in einem blendenden Lichtblitz!'), nl,
    write('Alle Drohnen weltweit fallen gleichzeitig vom Himmel.'), nl,
    write('Die Menschen von Linz und der ganzen Welt sind frei!'), nl,
    write('Du hast dein Leben für die Freiheit der Menschheit geopfert.'), nl,
    write('Du wirst als Held in Erinnerung bleiben!'), nl,
    write('ENDE: Der ultimative Held'), nl,
    halt.

end_game(dark_ruler) :-
    clear_screen,
    write('=== DUNKLER HERRSCHER ==='), nl,
    write('Die Drohnen schwärmen aus und überwachen jeden Winkel der Erde.'), nl,
    write('Unter deiner Kontrolle gibt es keine Verbrechen, keine Unordnung...'), nl,
    write('Aber auch keine Freiheit, keine Privatsphäre, keine Menschlichkeit.'), nl,
    write('Du sitzt auf einem Thron aus Überwachung und Kontrolle.'), nl,
    write('Die Welt ist "sicher" - aber zu welchem Preis?'), nl,
    write('ENDE: Der neue Überwacher'), nl,
    halt.

end_game(master_hacker_victory) :-
    clear_screen,
    write('=== MEISTER-HACKER TRIUMPH ==='), nl,
    write('Mit dem Master-Schlüssel hast du göttliche Kontrolle über das Netzwerk erlangt!'), nl,
    write('Du transformierst das gesamte System in einen Beschützer der Menschheit.'), nl,
    write('Die Drohnen werden zu Helfern: Sie retten Menschen, schützen die Umwelt'), nl,
    write('und überwachen nur noch wirkliche Bedrohungen.'), nl,
    write('Du hast die perfekte Balance zwischen Sicherheit und Freiheit geschaffen!'), nl,
    write('Die Welt ist in eine neue Ära des technologischen Friedens eingetreten.'), nl,
    write('ENDE: Der Meister-Hacker (Geheimes Ende)'), nl,
    halt.

end_game(hack_failure) :-
    clear_screen,
    write('=== HACK FEHLGESCHLAGEN ==='), nl,
    write('Deine Hacking-Versuche wurden entdeckt!'), nl,
    write('Sicherheitsdrohnen umzingeln dich!'), nl,
    write('Du wurdest gefangen genommen und das System läuft weiter...'), nl,
    write('GAME OVER'), nl,
    write('Vielleicht gibt es einen anderen Weg... einen geheimen Code?'), nl,
    write('Möchtest du es nochmal versuchen? Tippe "start_game." um neu zu beginnen.'), nl.

end_game(defeat) :-
    clear_screen,
    write('=== NIEDERLAGE ==='), nl,
    write('Du wurdest von den Drohnen überwältigt.'), nl,
    write('Die Wahrheit bleibt für immer begraben...'), nl,
    write('GAME OVER'), nl,
    write('Möchtest du es nochmal versuchen? Tippe "start_game." um neu zu beginnen.'), nl.

% ========== UTILITY PREDICATES ==========
get_random_damage(Damage) :-
    random(15, 26, Damage).  % Random damage between 15-25

get_random_enemy_damage(Damage) :-
    random(8, 16, Damage).  % Random enemy damage between 8-15

random_member(Element, List) :-
    length(List, Length),
    Length > 0,
    random(0, Length, RandomIndex),
    nth0(RandomIndex, List, Element).

write_sequence([]).
write_sequence([H|T]) :-
    write(H),
    (T = [] -> true ; write(' -> ')),
    write_sequence(T).

read_sequence(Sequence) :-
    read(Input),
    (is_list(Input) ->
        Sequence = Input ;
        Sequence = [Input]).

clear_screen :-
    catch(shell('clear'), _, (catch(shell('cls'), _, fail))).

% ========== HELP PREDICATES ==========
hilfe :- process_command([hilfe]).
schaue :- process_command([schaue]).
inventar :- process_command([inventar]).
status :- process_command([status]).

% Start predicate to begin the game
:- initialization(start_game).