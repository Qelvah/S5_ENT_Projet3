extends Node2D

var lives = 3
var score = 0
var spawn_point: Vector2

signal score_updated(new_score)
signal lives_updated(new_lives)

func _ready():
	spawn_point = get_node('SpawnPoint').global_position

func add_score(points):
	score += points
	print("Score: ", score)
	score_updated.emit(score)
	
func lose_life():
	lives -= 1
	lives_updated.emit(lives)
	
	# when hit respawns at spawn point
	var player = get_node('Player').get_node('CharacterBody2D')
	player.global_position = spawn_point
	
	if lives < 1:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
