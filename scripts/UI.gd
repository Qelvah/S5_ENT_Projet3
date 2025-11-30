extends CanvasLayer

var game_node

func _ready():
	game_node = get_parent().get_parent()
	game_node.score_updated.connect(update_score)
	game_node.lives_updated.connect(update_lives)
	update_lives(game_node.lives)
	update_score(game_node.score)
	
func update_score(new_score):
	$VBoxContainer/HBoxContainer2/Score.text = str(new_score)

func update_lives(new_lives):
	$VBoxContainer/HBoxContainer/Lives.text = str(new_lives)
