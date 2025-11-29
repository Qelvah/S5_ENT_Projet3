extends Area2D

var speed = 90
@onready var sprite = $AnimatedSprite2D

var direction = 1 # 1 = right, -1 = left
var left_limit = 230
var right_limit = 800

func _process(delta):
	position.x += speed * direction * delta

	if position.x >= right_limit:
		direction = -1
		$AnimatedSprite2D.flip_h = true
	elif position.x <= left_limit:
		direction = 1
		$AnimatedSprite2D.flip_h = false
