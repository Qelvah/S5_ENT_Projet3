extends Node2D

var lives = 3
var score = 0

signal score_updated(new_score)
signal lives_updated(new_lives)

func add_score(points):
	score += points
	print("Score: ", score)
	score_updated.emit(score)
	
func lose_life():
	lives -= 1
	lives_updated.emit(lives)
