extends Control

var Buttons = []
var ButtonIndex = 0
var MusicStream
var MusicList = {}
var SoundStream
var SoundList = {}

func _ready():
	# Initialize button array and focus first button
	Buttons = [
		$VBoxContainer/ButtonNewGame,
		$VBoxContainer/ButtonSettings,
		$VBoxContainer/ButtonExit,
	]
	Buttons[ButtonIndex].grab_focus()
	
	# Records mouse hovering
	for i in range(Buttons.size()):
		Buttons[i].connect("mouse_entered", Callable(self, "_on_button_hovered").bind(i))
	
	# Initialize music array and play the proper music
	MusicList["menu"] = preload("res://assets/sounds/music/05 - Login01.mp3")
	MusicStream = $VBoxContainer/ASP_Music
	activateAudio("music", "menu")
	
	# Initialize sound array
	SoundStream = $VBoxContainer/ASP_Sound
	SoundList["click"] = preload("res://assets/sounds/mixkit-select-click-1109.wav")
	SoundList["move"] = preload("res://assets/sounds/click-buttons-ui-menu-sounds-effects-button-13-205396.mp3")

# Enables W and S to be used to navigate menu on top of the default (arrows)
func _input(event):
	var previousIndex = ButtonIndex
	if (event is InputEventKey and event.pressed):
		if ((event.keycode == KEY_W or event.keycode == KEY_UP) and ButtonIndex >= 1):
			ButtonIndex -= 1
		else: if ((event.keycode == KEY_S or event.keycode == KEY_DOWN) and ButtonIndex < Buttons.size() -1):
			ButtonIndex += 1
		
		if (previousIndex != ButtonIndex): 
			Buttons[ButtonIndex].grab_focus()
			activateAudio("sound", "move")

# Launches the game
func _on_button_new_game_pressed():
	activateAudio("sound", "click")
	await get_tree().create_timer(0.2).timeout	
	get_tree().change_scene_to_file('res://scenes/Game.tscn')

# Opens the setting menu
func _on_button_settings_pressed():
	activateAudio("sound", "click")
	await get_tree().create_timer(0.2).timeout	
	print('settings')

# Quit game
func _on_button_exit_pressed():
	activateAudio("sound", "click")
	await get_tree().create_timer(0.2).timeout	
	get_tree().quit()

# Hovering behaviors
func _on_button_hovered(index):
	ButtonIndex = index
	Buttons[ButtonIndex].grab_focus()
	activateAudio("sound", "move")

# Reusable Music or Sound player
func activateAudio(type, key):
	if (type == "music"):
		MusicStream.stream = MusicList[key]
		MusicStream.play()
	else: if (type == "sound"):
		SoundStream.stream = SoundList[key]
		SoundStream.play()
