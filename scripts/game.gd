extends Node2D

var score = 0

func add_score(points):
	score += points
	$UI.update_score(score)

func on_player_death() -> void:
	$UI.update_lives($Player.lives)
