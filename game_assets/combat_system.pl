% ========== MAIN COMBAT LOOP ==========
combat_loop(Enemy) :-
    enemy(Enemy, DisplayName, Health, _),
    nl,
    write('=== KAMPF GEGEN '), write(DisplayName), write(' ==='), nl,
    write('Feind Gesundheit: '), write(Health), nl,
    player_health(PlayerHealth),
    write('Deine Gesundheit: '), write(PlayerHealth), nl,
    health_recovery_used(Enemy, RecoveryUsed),
    RemainingRecovery is 2 - RecoveryUsed,
    write('Heilungen übrig: '), write(RemainingRecovery), write('/2'), nl,
    write('Verfügbare Aktionen: angriff, heile, verwende(item)'), nl, nl,
    write('> '),
    read_line(Command),
    process_combat_command(Command, Enemy),
    check_game_state,
    !,
    game_loop.

% ========== COMBAT COMMANDS ==========
process_combat_command([angriff], Enemy) :-
    combat_attack(Enemy).

process_combat_command([verwende, Item], Enemy) :-
    combat_use_item(Item, Enemy).

process_combat_command([heile], Enemy) :-
    combat_heal(Enemy).

process_combat_command(_, _) :-
    write('Ungültige Kampfaktion! Verwende: angriff, heile oder verwende(item)'), nl.

% ========== TURN-BASED COMBAT SYSTEM ==========
start_combat(EnemyName) :-
    player_location(Loc),
    enemy_location(EnemyName, Loc),
    assertz(drone_cooldown(EnemyName, 0)),
    assertz(health_recovery_used(EnemyName, 0)),
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

combat_heal(Enemy) :-
    health_recovery_used(Enemy, Used),
    Used >= 2,
    write('Du hast bereits alle Heilungen in diesem Kampf verbraucht!'), nl,
    !.

combat_heal(_) :-
    player_health(CurrentHealth),
    CurrentHealth >= 100,
    write('Du hast bereits volle Gesundheit!'), nl,
    !.

combat_heal(Enemy) :-
    health_recovery_used(Enemy, Used),
    Used < 2,
    random(19, 31, HealAmount), 
    player_health(CurrentHealth),
    NewHealth is min(100, CurrentHealth + HealAmount),
    HealedAmount is NewHealth - CurrentHealth,
    retract(player_health(CurrentHealth)),
    assertz(player_health(NewHealth)),
    NewUsed is Used + 1,
    retract(health_recovery_used(Enemy, Used)),
    assertz(health_recovery_used(Enemy, NewUsed)),
    write('Du heilst dich selbst und gewinnst '), write(HealedAmount), 
    write(' Gesundheitspunkte!'), nl,
    RemainingUses is 2 - NewUsed,
    write('Verbleibende Heilungen: '), write(RemainingUses), nl,
    enemy_turn(Enemy).

% ========== COMBAT ITEMS ==========
execute_combat_item_use(emp_granate, Enemy) :-
    emp_used_in_combat(Enemy),
    write('Du hast bereits eine EMP-Granate in diesem Kampf verwendet!'), nl,
    !.

execute_combat_item_use(emp_granate, Enemy) :-
    enemy(Enemy, DisplayName, Health, Desc),
    assertz(emp_used_in_combat(Enemy)),
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
            (assertz(enemy(Enemy, DisplayName, NewHealth, Desc)),
             enemy_turn(Enemy))))).

execute_combat_item_use(kampfdrohne, Enemy) :-
    drone_cooldown(Enemy, Cooldown),
    Cooldown > 0,
    write('Deine Kampfdrohne lädt noch auf! Cooldown: '), write(Cooldown), write(' Runden.'), nl,
    !.

execute_combat_item_use(kampfdrohne, Enemy) :-
    enemy(Enemy, DisplayName, Health, Desc),
    Damage = 25,
    NewHealth is Health - Damage,
    write('Deine Kampfdrohne greift an und verursacht '), write(Damage), write(' Schaden!'), nl,
    write('Die Drohne muss sich jetzt 2 Runden lang aufladen.'), nl,
    % Set cooldown to 2 turns
    retract(drone_cooldown(Enemy, _)),
    assertz(drone_cooldown(Enemy, 2)),
    retract(enemy(Enemy, DisplayName, Health, Desc)),
    (NewHealth =< 0 ->
        (write(DisplayName), write(' wurde besiegt!'), nl,
         defeat_enemy(Enemy)) ;
        (assertz(enemy(Enemy, DisplayName, NewHealth, Desc)),
         enemy_turn(Enemy))).

execute_combat_item_use(heilspray, _) :-
    execute_item_use(heilspray).

execute_combat_item_use(Item, _) :-
    \+ member(Item, [emp_granate, kampfdrohne, heilspray]),
    item(Item, DisplayName, _),
    write(DisplayName), write(' kann nicht im Kampf verwendet werden!'), nl.

execute_combat_item_use(Item, _) :-
    write(Item), write(' kann nicht im Kampf verwendet werden!'), nl.

% ========== ENEMY-ATTACKS/DEFEAT ==========
enemy_turn(Enemy) :-
    drone_cooldown(Enemy, Cooldown),
    (Cooldown > 0 ->
        (NewCooldown is Cooldown - 1,
         retract(drone_cooldown(Enemy, Cooldown)),
         assertz(drone_cooldown(Enemy, NewCooldown))) ;
        true),
    enemy(Enemy, DisplayName, _, _),
    (Enemy = die_kraehe, game_state(crow_weakened, false) ->
        crow_mind_control ;
        normal_enemy_attack(Enemy, DisplayName)).

normal_enemy_attack(_, DisplayName) :-
    get_random_enemy_damage(Damage),
    damage_player(Damage),
    write(DisplayName), write(' greift an und verursacht '), 
    write(Damage), write(' Schaden!'), nl.

crow_mind_control :-
    write('Die Krähe übernimmt die Kontrolle über deinen Verstand!'), nl,
    write('Du schlägst dich selbst!'), nl,
    damage_player(20),
    write('Du verursachst dir '), write(20), write(' Schaden!'), nl.

defeat_enemy(EnemyName) :-
    retract(enemy_location(EnemyName, _)),
    retract(in_combat(EnemyName)),
    handle_enemy_defeat(EnemyName),
    retractall(emp_used_in_combat(EnemyName)),
    retractall(drone_cooldown(EnemyName, _)),
    retractall(health_recovery_used(EnemyName, _)),
    nl.