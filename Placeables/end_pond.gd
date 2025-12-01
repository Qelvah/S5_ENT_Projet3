extends Area2D
class_name EndPond

# -----------------------------------
#                SIGNALS
# -----------------------------------
signal on_player_reach      # Émis lorsque le joueur atteint l'étang final


# -----------------------------------
#           INITIALISATION
# -----------------------------------
func _ready() -> void:
	# La grenouille est cachée au départ.
	$FrogSprite.visible = false


# -----------------------------------
#      DÉTECTION DU JOUEUR (AREA2D)
# -----------------------------------
func _on_player_entered(_player: Node2D) -> void:
	# Affiche la grenouille
	$FrogSprite.visible = true

	# Émet le signal pour prévenir le jeu que le joueur a atteint la zone.
	on_player_reach.emit()
