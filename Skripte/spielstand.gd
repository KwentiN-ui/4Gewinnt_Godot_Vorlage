extends Node

var area: Area3D = null
const SPALTENBREITE: float = 0.045

func _process(_delta):
    # Alle Spielsteine in Array fassen
    var steine = []
    if area:
        for body in area.get_overlapping_bodies():
            if body is Spielstein:
                steine.append(body)
    
    # 2D Matrix erzeugen welche Positionen der Steine enthält
    var stein_matrix = []
    for i in range(7):
        stein_matrix.append([])
    
    if not steine.is_empty():
        # Jeden Spielstein der passenden Spalte zuordnen
        for stein in steine:
            var lokale_position = area.to_local(stein.global_position)
            for i in range(7):
                if lokale_position.x < (i * SPALTENBREITE) - 0.111:
                    stein_matrix[i].append(stein)
                    break
        
        # Spalten nach Y-Koordinate sortieren
        for spalte in stein_matrix:
            spalte.sort_custom(sort_by_y)
        
    var spielpositionen = []
    for i in range(7):
        spielpositionen.append([0, 0, 0, 0, 0, 0])
    for i in range(len(stein_matrix)):
        for j in range(len(stein_matrix[i])):
            spielpositionen[i][j] = stein_matrix[i][j].spieler
    
    # Darstellung der Spielpositionen
    for i in range(len(spielpositionen)):
        DebugDraw2D.set_text("Spalte " + str(i), spielpositionen[i])

func sort_by_y(stein: Spielstein, anderer_stein: Spielstein):
    return stein.global_position.y < anderer_stein.global_position.y