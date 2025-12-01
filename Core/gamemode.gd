extends Node2D
class_name Gamemode

# ----------------------------
#        VARIABLES
# ----------------------------
var score: int = 0     
var end_reach_amount: int = 0                                        		# Score actuel du joueur
var main_menu_scene: PackedScene = load("res://UI/main_menu.tscn")    # Scène du menu principal
var loop: int = 1



# ----------------------------
#         FONCTION READY
# ----------------------------
func _ready() -> void:
	# Connecte tous les points de fin à la fonction appelée quand le joueur atteint la ligne
	var ends: Array[Node] = $EndPonds.get_children()
	for end in ends:
		end.connect("on_player_reach", on_an_end_reached)


# ----------------------------
#        GESTION DU SCORE
# ----------------------------
func add_score(points: int) -> void:
	score += points                 # Ajoute les points
	$HUD.update_score(score)         # Met à jour l'affichage du score


# ----------------------------
#   GESTION DES VIES DU PLAYER
# ----------------------------
func on_player_death() -> void:
	# Met à jour l'affichage du nombre de vies restantes
	$HUD.update_lives($Player.lives)


# ----------------------------
#    GESTION DES FINS ATTEINTES
# ----------------------------
func on_an_end_reached() -> void:
	end_reach_amount += 1
	add_score(3)
	if end_reach_amount == 5 :
		finish_loop()
	else:
		# Remet le joueur au point de départ après avoir atteint une zone d’arrivée
		$Player.respawn()


# ----------------------------
#       GAME OVER DU PLAYER
# ----------------------------
func _on_player_gameover() -> void:
	# Charge et affiche le menu principal
	var menu: Node = main_menu_scene.instantiate()
	get_parent().add_child(menu)

	# Détruit cette scène de game manager
	queue_free()

func finish_loop():
	loop += 1
	
	for pond in $EndPonds.get_children():
		pond.reset();
	
	for car in $Cars.get_children():
		car.queue_free()
		
	for spawner in $CarSpawners.get_children():
		spawner.initiate()
	
	$Player.respawn()
	
