% ========== ITEMS ==========
item(laptop, 'Laptop', 'Dein vertrauter Laptop mit Hacking-Software.').
item(emp_granate, 'EMP-Granate', 'Eine elektromagnetische Impulsgranate gegen elektrische Systeme.').
item(parkour_handschuhe, 'Parkour-Handschuhe', 'Verbessern deinen Grip beim Klettern.').
item(kampfdrohne, 'Kampfdrohne', 'Deine selbstgebaute Verteidigungsdrohne.').
item(emp_generator, 'EMP-Generator', 'Ein mächtiger EMP-Generator gegen das Sischerheitssytem des Aviary HQs.').
item(spule, 'Elektro-Spule', 'Eine hochwertige Induktionsspule.').
item(batterie, 'Hochleistungsbatterie', 'Eine spezielle Batterie für EMP-Geräte.').
item(kondensator, 'Kondensator', 'Ein Hochspannungskondensator.').
item(heilspray, 'Heilspray', 'Regeneriert 30 Gesundheitspunkte.').
item(drohnen_motor, 'Drohnen-Motor', 'Ein kleiner Motor für Drohnen-Antrieb.').
item(steuerungsmodul, 'Steuerungsmodul', 'Elektronisches Modul zur Drohnen-Steuerung.').
item(master_schluessel, 'Master-Schlüssel', 'Ein geheimnisvoller Schlüssel mit Aviary-Logo. Gewährt vollständigen Systemzugriff.').

% ========== INITIAL ITEM LOCATIONS ==========
init_items :-
    retractall(item_location(_, _)),
    retractall(player_inventory(_)),
    assertz(player_inventory(laptop)),
    assertz(item_location(emp_granate, htl_werkstatt)),
    assertz(item_location(emp_granate, htl_werkstatt)),
    assertz(item_location(parkour_handschuhe, altstadt)),
    assertz(item_location(heilspray, htl_labor)).
