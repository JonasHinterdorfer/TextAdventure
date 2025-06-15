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
    assertz(enemy_hack_attempted(EnemyName, false)),
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

execute_combat_item_use(laptop, Enemy) :-
    hack_enemy(Enemy).

execute_combat_item_use(heilspray, _) :-
    execute_item_use(heilspray).

execute_combat_item_use(Item, _) :-
    \+ member(Item, [emp_granate, kampfdrohne, laptop, heilspray]),
    item(Item, DisplayName, _),
    write(DisplayName), write(' kann nicht im Kampf verwendet werden!'), nl.

execute_combat_item_use(Item, _) :-
    write(Item), write(' kann nicht im Kampf verwendet werden!'), nl.

% ========== ENEMY HACKING SYSTEM ==========
hack_enemy(Enemy) :-
    enemy_hack_attempted(Enemy, true),
    write('Du hast bereits versucht, diesen Feind zu hacken!'), nl,
    !.

hack_enemy(Enemy) :-
    retract(enemy_hack_attempted(Enemy, false)),
    assertz(enemy_hack_attempted(Enemy, true)),
    enemy(Enemy, DisplayName, _, _),
    write('=== FEIND HACKEN ==='), nl,
    write('Du versuchst '), write(DisplayName), write(' zu hacken...'), nl,
    enemy_hacking_minigame(Enemy).

% ========== ENEMY HACKING MINI-GAMES ==========
% Tauben-Schwarm: 1 Frage (Einfach)
enemy_hacking_minigame(tauben_schwarm) :-
    write('=== SCHWARM-NETZWERK INFILTRATION ==='), nl,
    write('Welches Protokoll verwenden IoT-Geräte hauptsächlich für Machine-to-Machine Kommunikation?'), nl,
    write('1) HTTP'), nl,
    write('2) MQTT'), nl,
    write('3) FTP'), nl,
    write('4) SMTP'), nl,
    write('Deine Wahl (1-4): '),
    read(Answer),
    (Answer = 2 ->
        successful_hack(tauben_schwarm, 25) ;
        failed_hack(tauben_schwarm)).

% Storch-Drohne: 2 Fragen (Mittel)
enemy_hacking_minigame(storch_drohne) :-
    write('=== KAMPFDROHNEN-SYSTEM HACKEN ==='), nl,
    write('Frage 1/2: In welcher Schicht des OSI-Modells arbeiten Router hauptsächlich?'), nl,
    write('1) Layer 2 (Data Link)'), nl,
    write('2) Layer 7 (Application)'), nl,
    write('3) Layer 4 (Transport)'), nl,
    write('4) Layer 3 (Network)'), nl,
    write('Deine Wahl (1-4): '),
    read(Answer1),
    (Answer1 = 4 ->
        (write('Korrekt! Nächste Frage...'), nl,
         write('Frage 2/2: Welcher Angriff nutzt Buffer Overflow aus?'), nl,
         write('1) Return-to-libc'), nl,
         write('2) Man-in-the-Middle'), nl,
         write('3) Cross-Site Scripting'), nl,
         write('4) DNS Spoofing'), nl,
         write('Deine Wahl (1-4): '),
         read(Answer2),
         (Answer2 = 1 ->
            successful_hack(storch_drohne, 35) ;
            failed_hack(storch_drohne))) ;
        failed_hack(storch_drohne)).

% Die Krähe: 3 Fragen (Schwer)
enemy_hacking_minigame(die_kraehe) :-
    write('=== MASTER-KI INFILTRATION ==='), nl,
    write('Frage 1/3: Welche Verschlüsselung ist quantenresistent?'), nl,
    write('1) RSA-2048'), nl,
    write('2) Lattice-based Cryptography'), nl,
    write('3) Elliptic Curve'), nl,
    write('Deine Wahl (1-3): '),
    read(Answer1),
    (Answer1 = 2 ->
        (write('Korrekt! Nächste Frage...'), nl,
         write('Frage 2/3: Was ist ein Zero-Day Exploit?'), nl,
         write('1) Ein Exploit ohne bekannte Patches'), nl,
         write('2) Ein Exploit, der täglich funktioniert'), nl,
         write('3) Ein Exploit, der sofort erkannt wird'), nl,
         write('4) Ein Exploit mit null Schaden'), nl,
         write('Deine Wahl (1-4): '),
         read(Answer2),
         (Answer2 = 1 ->
            (write('Korrekt! Letzte Frage...'), nl,
             write('Frage 3/3: Welche Technik verwendet ROP (Return-Oriented Programming)?'), nl,
             write('1) Heap Spraying'), nl,
             write('2) Code Injection'), nl,
             write('3) Gadget Chaining'), nl,
             write('4) Format String Bugs'), nl,
             write('Deine Wahl (1-4): '),
             read(Answer3),
             (Answer3 = 3 ->
                successful_hack(die_kraehe, 50) ;
                failed_hack(die_kraehe))) ;
            failed_hack(die_kraehe))) ;
        failed_hack(die_kraehe)).

% ========== HACK RESULTS ==========
successful_hack(Enemy, Damage) :-
    enemy(Enemy, DisplayName, Health, Desc),
    write('*** HACK ERFOLGREICH ***'), nl,
    write('Du übernimmst temporär die Kontrolle über '), write(DisplayName), write('!'), nl,
    write('Der Feind greift sich selbst an und erleidet '), write(Damage), write(' Schaden!'), nl,
    NewHealth is Health - Damage,
    retract(enemy(Enemy, DisplayName, Health, Desc)),
    (NewHealth =< 0 ->
        (write(DisplayName), write(' wurde durch den Hack zerstört!'), nl,
         defeat_enemy(Enemy)) ;
        (assertz(enemy(Enemy, DisplayName, NewHealth, Desc)),
         write('Das System erholt sich... Der Feind ist wieder unter eigener Kontrolle.'), nl,
         enemy_turn(Enemy))).

failed_hack(Enemy) :-
    enemy(Enemy, DisplayName, _, _),
    write('*** HACK FEHLGESCHLAGEN ***'), nl,
    write('Dein Hack-Versuch wurde von '), write(DisplayName), write(' erkannt!'), nl,
    write('Das System verstärkt seine Verteidigung und greift zurück!'), nl,
    % Enemy gets an extra strong attack for failed hack
    get_random_enemy_damage(BaseDamage),
    ExtraDamage is BaseDamage + 10,
    damage_player(ExtraDamage),
    write(DisplayName), write(' führt einen verstärkten Gegenangriff aus und verursacht '), 
    write(ExtraDamage), write(' Schaden!'), nl.

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
    retractall(enemy_hack_attempted(EnemyName, _)),
    nl.