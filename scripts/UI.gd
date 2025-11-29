extends CanvasLayer

@onready var score_amount = $VBoxContainer/Label_score_amount
@onready var lives_amount = $VBoxContainer/Label_lives_amount
var game_node

func _ready():
	game_node = get_parent().get_parent()
	game_node.score_updated.connect(update_score)
	game_node.lives_updated.connect(update_lives)
	update_lives(game_node.lives)
	update_score(game_node.score)
	
func update_score(new_score):
	score_amount.text = str(new_score)

func update_lives(new_lives):
	lives_amount.text = str(new_lives)
