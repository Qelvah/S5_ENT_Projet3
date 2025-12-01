extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var game_node = get_parent().get_parent().get_parent()
		game_node.add_score(1)
		self.queue_free()
