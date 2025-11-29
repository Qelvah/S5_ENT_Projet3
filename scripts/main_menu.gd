extends Control

const CONFIG_PATH := "user://settings.cfg"
var Buttons = []
var ButtonIndex = 0
var MusicStream
var MusicList = {}
var SoundStream
var SoundList = {}
var resolutions = [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920,1080)]

func _ready():
	# Initialize button array and focus first button
	Buttons = [
		$VBoxContainer/ButtonNewGame,
		$VBoxContainer/ButtonSettings,
		$VBoxContainer/ButtonExit,
	]
	Buttons[ButtonIndex].grab_focus()
	
	# Initialize settings
	load_settings()
	
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
	
func load_settings():
	load_audio_setting()
	load_fullscreen_setting()
	load_resolution_setting()

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
		
		if (event.keycode == KEY_F or event.keycode == KEY_ENTER):
			Buttons[ButtonIndex].emit_signal("pressed")

# Hovering behaviors
func _on_button_hovered(index):
	ButtonIndex = index
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
	get_tree().change_scene_to_file("res://scenes/SettingsMenu.tscn")

# Quit game
func _on_button_exit_pressed():
	activateAudio("sound", "click")
	await get_tree().create_timer(0.2).timeout	
	get_tree().quit()

# Load audio settings if files exists
func load_audio_setting():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)

	if (err == OK):
		var volume = config.get_value("audio", "master_volume", 1.0)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))

func load_fullscreen_setting():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	
	if (err == OK): 
		var fullscreen = config.get_value('video', 'fullscreen', false)
		if (fullscreen == true):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)

func load_resolution_setting():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	
	if(err == OK):
		var resolutionSaved = config.get_value('video', 'resolution', 0)
		DisplayServer.window_set_size(resolutions[resolutionSaved])

# Activates music or sound based on index
func activateAudio(type, key):
	if (type == "music"):
		MusicStream.stream = MusicList[key]
		MusicStream.play()
	else: if (type == "sound"):
		SoundStream.stream = SoundList[key]
		SoundStream.play()
