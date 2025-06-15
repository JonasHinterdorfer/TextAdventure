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