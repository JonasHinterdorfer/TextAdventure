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