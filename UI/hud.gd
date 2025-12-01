extends Control

# -----------------------------------
#     MISE À JOUR DE L'AFFICHAGE SCORE
# -----------------------------------
func update_score(new_score):
	# Convertit la valeur du score en texte
	# et l'affiche dans le Label prévu à cet effet.
	$CanvasLayer/VBoxContainer/HBoxContainer2/Score.text = str(new_score)


# -----------------------------------
#     MISE À JOUR DE L'AFFICHAGE VIES
# -----------------------------------
func update_lives(new_lives):
	# Convertit le nombre de vies en texte
	# et l'affiche dans le Label correspondant.
	$CanvasLayer/VBoxContainer/HBoxContainer/Lives.text = str(new_lives)
