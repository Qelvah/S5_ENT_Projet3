extends Area2D

@export var is_left: bool = false
@export var speed: int = 20
@export var model: int = 0
@export var cars: Array[Texture2D] = []

var camera_offset: int = 50
var limit: int = 256 + camera_offset

var dir: int = 1

func _ready() -> void:
	$Sprite2D.texture = cars[model]
	
	if (is_left):
		$Sprite2D.flip_h = true

func _process(delta):
	if is_left:
		dir = -1
		
	position.x += speed * dir * delta

	if position.x >= limit or position.x <= -limit:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.lose_life()
