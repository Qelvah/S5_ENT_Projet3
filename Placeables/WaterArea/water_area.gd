extends Area2D
var player : Node = null

func _process(_delta):
	call_deferred('water_check', player)

func _on_body_entered(body: Node2D) -> void:
	player = body
	call_deferred('water_check', body)

func water_check(body: Node2D) -> void:
	if (body):
		if (body.water_safe == false):
			body.die()

func _on_body_exited(_body: Node2D) -> void:
	player = null
