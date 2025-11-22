extends CharacterBody2D

var speed = 120
@onready var sprite := $AnimatedSprite2D

func _physics_process(delta):
	var input_vector := Vector2.ZERO
	
	## else if pour empêcher diagonal
	if (Input.is_action_pressed("walk_up")):
		input_vector.y -= 1
		sprite.animation = "walk_top"
	else: if(Input.is_action_pressed("walk_down")):
		input_vector.y += 1
		sprite.animation = "walk_bottom"
	else: if (Input.is_action_pressed("walk_left")):
		input_vector.x -= 1
		sprite.animation = "walk_left"
	else: if (Input.is_action_pressed("walk_right")):
		input_vector.x += 1
		sprite.animation = "walk_right"
		
	velocity = input_vector.normalized() * speed
	move_and_slide()
	
