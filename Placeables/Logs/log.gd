extends Area2D

@export var is_left: bool = false
@export var speed = 50

var camera_offset: int = 50
var limit: int = 256 + camera_offset

var dir: int = 1
var on_log = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_left:
		dir = -1
	var movement = speed * dir * delta
	position.x += movement
	
	for player in on_log:
		player.position.x += movement
		player.water_safe = true
		
	if position.x >= limit or position.x <= -limit:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.log_partner = self
	body.water_safe = true
	on_log.append(body)


func _on_body_exited(body: Node2D) -> void:
	body.log_partner = null
	body.water_safe = false
	on_log.erase(body)
