extends CharacterBody2D
class_name Player
# ----------------------------
#         VARIABLES
# ----------------------------
var input_vector := Vector2.ZERO            # Direction du mouvement (unitaire)
var is_moving: bool = false					# Vérifie si un mouvement est déjà en cours
var is_hit: bool = false             		# Vérifie si le joueur est déjà touché
var speed: int = 16                        # Distance parcourue par saut
var lives: int = 3                         # Nombre de vies du joueur
var log_partners : Array = []
var water_safe = false
var move_tween: Tween = null               # Tween responsable du déplacement

# ----------------------------
#          SIGNAUX
# ----------------------------
signal on_player_death                     # Émis lorsque le joueur perd une vie
signal on_player_gameover                  # Émis lorsque le joueur n’a plus de vies


# ----------------------------
#      FONCTIONS PRINCIPALES
# ----------------------------
func _process(_delta) -> void:
	if (is_out_of_bound()):
		die()
		
	# Ne traite pas de nouvelle entrée si un mouvement est en cours
	if is_moving:
		return

	# Réinitialise le vecteur d'entrée
	input_vector = Vector2.ZERO
	
	# Lecture du premier input pressé
	if Input.is_action_just_pressed("walk_up"):
		input_vector.y = -1
	elif Input.is_action_just_pressed("walk_down"):
		input_vector.y = 1
	elif Input.is_action_just_pressed("walk_left"):
		input_vector.x = -1
	elif Input.is_action_just_pressed("walk_right"):
		input_vector.x = 1
		

	# Déplace le joueur si une direction a été entrée
	if input_vector != Vector2.ZERO:
		move_player(input_vector)

# ----------------------------
#      GESTION DU MOUVEMENT
# ----------------------------
func move_player(dir: Vector2):
	is_moving = true

	var space_state := get_world_2d().direct_space_state
	var target_pos: Vector2 = global_position + dir * speed

	var shape: Shape2D = $CollisionShape2D.shape
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.exclude = [self]

	var transform: Transform2D = $CollisionShape2D.global_transform
	transform.origin = target_pos
	params.transform = transform

	var result := space_state.intersect_shape(params, 1)

	if result.size() > 0:
		print("Blocked by: ", result[0].collider)
		is_moving = false
		return

	# Oriente le sprite selon la direction
	if dir == Vector2.UP:
		rotation_degrees = 0
	elif dir == Vector2.DOWN:
		rotation_degrees = 180
	elif dir == Vector2.LEFT:
		rotation_degrees = -90
	elif dir == Vector2.RIGHT:
		rotation_degrees = 90

	# Position d'arrivée
	target_pos = position + dir * speed
	
	# Adjust based on log collision
	if (!log_partners.is_empty()):
		for log in log_partners:
			if log is Log and log.speed:
				target_pos += Vector2(log.speed * (-1 if log.is_left else 1) * 0.2, 0)
	# Animation de saut
	$Sprite.animation = "jump"

	# Tween du mouvement
	move_tween = create_tween()
	move_tween.tween_property(self, "position", target_pos, 0.2)
	move_tween.connect("finished", on_tween_finished)


func on_tween_finished():
	# Retour à l’animation idle une fois le déplacement terminé
	$Sprite.animation = "idle"
	is_moving = false

	# Assure un positionnement propre sur la grille (pixel perfect)
	position = position.floor()
	if is_hit: is_hit = false


# ----------------------------
#       GESTION DES VIES
# ----------------------------
func die():
	if (is_hit != true):
		is_hit = true
		print(lives)
		lives -= 1
		on_player_death.emit()

		if lives < 1:
			on_player_gameover.emit()
		else:
			respawn()

# ----------------------------
#       RESPAWN DU PLAYER
# ----------------------------
func respawn():
	# Si un tween était en cours, on le stoppe proprement
	if move_tween and move_tween.is_running():
		is_moving = false
		move_tween.kill()
		move_tween = null

	# Replace le joueur au point de spawn du niveau
	global_position = get_parent().get_node("SpawnPoint").global_position
	
	# Remet dans l'animation Idle
	$Sprite.animation = "idle"
	
# ----------------------------
#       OOB Check
# ----------------------------
func is_out_of_bound():
	var x_check = position.x < 0 or position.x > DisplayServer.window_get_size().x
	var y_check = position.y < 0 or position.y > DisplayServer.window_get_size().y
	
	return (x_check or y_check)
