extends CharacterBody2D

var input_vector := Vector2.ZERO
var is_moving: bool = false
var speed: int = 16

var lives = 3
signal on_player_death()

func _process(_delta) -> void:
	if is_moving:
		return  # empêchez un nouveau mouvement tant que le tween n'est pas fini
		
	input_vector = Vector2.ZERO
	
	if Input.is_action_just_pressed("walk_up"):
		input_vector.y = -1
	elif Input.is_action_just_pressed("walk_down"):
		input_vector.y = 1
	elif Input.is_action_just_pressed("walk_left"):
		input_vector.x = -1
	elif Input.is_action_just_pressed("walk_right"):
		input_vector.x = 1

	if input_vector != Vector2.ZERO:
		move_player(input_vector)


func move_player(dir: Vector2):
	is_moving = true
	
	# --- Rotation du player selon la direction ---
	if dir == Vector2.UP:
		rotation_degrees = 0
	elif dir == Vector2.DOWN:
		rotation_degrees = 180
	elif dir == Vector2.LEFT:
		rotation_degrees = -90
	elif dir == Vector2.RIGHT:
		rotation_degrees = 90

	var target_pos: Vector2 = position + dir * speed
	
	$Sprite.animation = "jump"

	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_pos, 0.2)

	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	$Sprite.animation = "idle"
	is_moving = false
	position = position.floor() # pixel perfect

func lose_life():
	global_position = get_parent().get_node('SpawnPoint').global_position
	lives -= 1
	on_player_death.emit()
	
	if lives < 1:
		var main_menu_scene = load("res://scenes/core/MainMenu.tscn")
		var menu = main_menu_scene.instantiate()
		get_parent().get_parent().add_child(menu)
		get_parent().queue_free()
