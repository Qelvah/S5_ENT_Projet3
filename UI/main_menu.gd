extends Control

# -------------------------------------------------
#                 CONSTANTES / VARIABLES
# -------------------------------------------------
var Buttons: Array[Variant] = []             # Liste des boutons du menu
var ButtonIndex: int = 0                     # Bouton actuellement sélectionné via clavier

# -------------------------------------------------
#                      READY
# -------------------------------------------------
func _ready():
	# Récupère tous les boutons du menu
	Buttons = [
		$CanvasLayer/VBoxContainer/ButtonNewGame,
		$CanvasLayer/VBoxContainer/ButtonSettings,
		$CanvasLayer/VBoxContainer/ButtonExit,
	]

	# Met le focus sur le premier bouton
	Buttons[ButtonIndex].grab_focus()

	
	# Connecte les signaux de hover pour détecter quand la souris passe sur un bouton
	for i in range(Buttons.size()):
		Buttons[i].connect("mouse_entered", Callable(self, "_on_button_hovered").bind(i))

# -------------------------------------------------
#     NAVIGATION AU CLAVIER (W/S + flèches)
# -------------------------------------------------
func _input(event):
	var previousIndex: int = ButtonIndex

	if event is InputEventKey and event.pressed:

		# Déplacement vers le haut (W ou flèche haut)
		if (event.keycode == KEY_W or event.keycode == KEY_UP) and ButtonIndex >= 1:
			ButtonIndex -= 1

		# Déplacement vers le bas (S ou flèche bas)
		elif (event.keycode == KEY_S or event.keycode == KEY_DOWN) and ButtonIndex < Buttons.size() - 1:
			ButtonIndex += 1

		# Si l’index a changé → changer le focus + jouer un son de hover
		if previousIndex != ButtonIndex:
			Buttons[ButtonIndex].grab_focus()
			$SFX_Hover.play()

		# Validation du bouton (Entrée ou F)
		if event.keycode == KEY_F or event.keycode == KEY_ENTER:
			Buttons[ButtonIndex].emit_signal("pressed")


# -------------------------------------------------
#        HOVER (souris) SUR UN BOUTON
# -------------------------------------------------
func _on_button_hovered(index):
	ButtonIndex = index                    # Change l’index lié au bouton pointé par la souris
	Buttons[ButtonIndex].grab_focus()      # Donne le focus à ce bouton
	$SFX_Hover.play()                      # Joue le son de hover


# -------------------------------------------------
#                   LANCER UNE PARTIE
# -------------------------------------------------
func _on_button_new_game_pressed():
	$SFX_Pressed.play()
	await get_tree().create_timer(0.2).timeout

	var gamemode_scene: PackedScene = preload("res://Core/gamemode.tscn")
	var gamemode: Node = gamemode_scene.instantiate()

	get_parent().add_child(gamemode)
	queue_free()  # Ferme le menu


# -------------------------------------------------
#                OUVRIR LE MENU SETTINGS
# -------------------------------------------------
func _on_button_settings_pressed():
	$SFX_Pressed.play()
	await get_tree().create_timer(0.2).timeout

	var gamemode_scene: PackedScene = preload("res://UI/settings_menu.tscn")
	var gamemode: Node = gamemode_scene.instantiate()

	get_parent().add_child(gamemode)
	queue_free()


# -------------------------------------------------
#                       QUITTER
# -------------------------------------------------
func _on_button_exit_pressed():
	$SFX_Pressed.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
