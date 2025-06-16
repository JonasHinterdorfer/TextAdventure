% SkyNet: The Wings of Deception
% Von Zsombor Matyas und Jonas Hinterdorfer

% ========== INCLUDES ==========
:- include('game_assets/climbing_system.pl').
:- include('game_assets/combat_system.pl').
:- include('game_assets/command_processing.pl').
:- include('game_assets/commands.pl').
:- include('game_assets/crafting_system.pl').
:- include('game_assets/endings.pl').
:- include('game_assets/game_state.pl').
:- include('game_assets/hacking_system.pl').
:- include('game_assets/inventory.pl').
:- include('game_assets/items.pl').
:- include('game_assets/konami_code.pl').
:- include('game_assets/locations.pl').
:- include('game_assets/npcs.pl').
:- include('game_assets/obstacles.pl').
:- include('game_assets/parkour_minigames.pl').
:- include('game_assets/utilities.pl').

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
    retractall(emp_used_in_combat(_)),
    retractall(drone_cooldown(_, _)),
    retractall(health_recovery_used(_, _)),
    retractall(chapter(_)),

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
    assertz(drone_cooldown(none, 0)),
    assertz(chapter(0)),

    % Initialize obstacles
    init_obstacles.

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
    write('Für deine nächsten Ziele schreibe \'status.\''), nl, nl.

game_loop :-
    (in_combat(Enemy) -> combat_loop(Enemy) ; normal_loop).

normal_loop :-
    player_location(Loc),
    location(Loc, Name, _),
    write('Du befindest dich in: '), write(Name), nl,
    write('> '),
    read_line(Command),
    process_command(Command),
    nl,
    check_game_state,
    !,
    game_loop.

% Start predicate to begin the game
:- initialization(start_game).
