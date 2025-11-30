extends Control

var game_node
	
func update_score(new_score):
	$CanvasLayer/VBoxContainer/HBoxContainer2/Score.text = str(new_score)

func update_lives(new_lives):
	$CanvasLayer/VBoxContainer/HBoxContainer/Lives.text = str(new_lives)
