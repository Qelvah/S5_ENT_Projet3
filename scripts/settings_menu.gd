extends Control

const CONFIG_PATH := "user://settings.cfg"
var SettingsMenu = []
var ButtonIndex = 0
var MusicStream
var MusicList = {}
var SoundStream
var SoundList = {}
var resolutions = [Vector2i(256, 256), Vector2i(338, 338), Vector2i(420,420)]

func _ready():
	# Initialize resolution dropdown
	var resolutionDropdown = $VBoxContainer/ResolutionDropdown
	resolutionDropdown.clear()
	for res in resolutions:
		resolutionDropdown.add_item("%dx%d" % [res.x, res.y])
		
	load_audio_setting()
	load_resolution_setting()
	load_fullscreen_setting()
	connect_signals()
	# Grabs the audio slider to enable keyboard inputs
	SettingsMenu = [$VBoxContainer/AudioSlider, $VBoxContainer/ResolutionDropdown, $VBoxContainer/FSCheck, $VBoxContainer/Button_Back]
	SettingsMenu[ButtonIndex].grab_focus()
	
	# Initialize music array and play the proper music
	MusicList["menu"] = preload("res://assets/sounds/music/BGM_Menu.mp3")
	MusicStream = $VBoxContainer/ASP_Music
	activateAudio("music", "menu")
	
	# Initialize sound array
	SoundStream = $VBoxContainer/ASP_Sound
	SoundList["click"] = preload("res://assets/sounds/SFX_Click.wav")
	SoundList["move"] = preload("res://assets/sounds/SFX_Hover.mp3")

# Enables W and S to be used to navigate menu on top of the default (arrows)
func _input(event):
	var resolutionDropdown = $VBoxContainer/ResolutionDropdown
	var audioSlider = $VBoxContainer/AudioSlider
	var previousIndex = ButtonIndex
	
	if (event is InputEventKey and event.pressed):
		if ((event.keycode == KEY_W or event.keycode == KEY_UP) and ButtonIndex >= 1):
			ButtonIndex -= 1
		else: if ((event.keycode == KEY_S or event.keycode == KEY_DOWN) and ButtonIndex < SettingsMenu.size() -1):
			ButtonIndex += 1
		elif((event.keycode == KEY_A or event.keycode == KEY_LEFT) and ButtonIndex == 0):
			if (audioSlider.value > 0):
				audioSlider.value -= 0.01
		elif((event.keycode == KEY_D or event.keycode == KEY_RIGHT) and ButtonIndex == 0):
			if (audioSlider.value < 1):
				audioSlider.value += 0.01
		elif((event.keycode == KEY_A or event.keycode == KEY_LEFT) and ButtonIndex == 1):
			if (resolutionDropdown.selected > 0):
				resolutionDropdown.select(resolutionDropdown.selected - 1)
				DisplayServer.window_set_size(resolutions[resolutionDropdown.selected])
		elif((event.keycode == KEY_D or event.keycode == KEY_RIGHT) and ButtonIndex == 1):
			if (resolutionDropdown.selected < resolutions.size()):
				resolutionDropdown.select(resolutionDropdown.selected + 1)
				DisplayServer.window_set_size(resolutions[resolutionDropdown.selected])

		
		if (previousIndex != ButtonIndex): 
			SettingsMenu[ButtonIndex].grab_focus()
			activateAudio("sound", "move")
		
		if (event.keycode == KEY_F or event.keycode == KEY_ENTER):
			SettingsMenu[ButtonIndex].emit_signal("pressed")
		elif(event.keycode == KEY_ESCAPE):
			_on_button_back_pressed()

# Hovering behaviors
func _on_button_hovered(index):
	ButtonIndex = index
	SettingsMenu[ButtonIndex].grab_focus()
	activateAudio("sound", "move")

# Activates music or sound based on index
func activateAudio(type, key):
	if (type == "music"):
		MusicStream.stream = MusicList[key]
		MusicStream.play()
	else: if (type == "sound"):
		SoundStream.stream = SoundList[key]
		SoundStream.play()

# When option changes, triggers adjustment and save
func connect_signals():
	$VBoxContainer/AudioSlider.value_changed.connect(_on_audio_changed)
	$VBoxContainer/FSCheck.toggled.connect(_on_fullscreen_toggled)
	$VBoxContainer/ResolutionDropdown.item_selected.connect(_on_resolution_selected)

# Load audio to slider 
func load_audio_setting():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	var audioSlider = $VBoxContainer/AudioSlider

	if err == OK and audioSlider:
		audioSlider.value = config.get_value("audio", "master_volume", 1.0)
	else:
		audioSlider.value = 1.0
		save_audio_setting(audioSlider.value)

func _on_audio_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	save_audio_setting(value)

func save_audio_setting(value):
	var config = ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value("audio", "master_volume", float(value))
	config.save(CONFIG_PATH)	

func load_fullscreen_setting():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	var FSCheck = $VBoxContainer/FSCheck
	
	if (err == OK and FSCheck):
		FSCheck.button_pressed = config.get_value('video', 'fullscreen', false)
	else:
		save_fullscreen_setting(FSCheck.button_pressed)
	
func _on_fullscreen_toggled(value):
	if (value == true):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_fullscreen_setting(value)

func save_fullscreen_setting(value):
	var config = ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value('video', 'fullscreen', value)
	config.save(CONFIG_PATH)

func load_resolution_setting():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	var resolutionDrop = $VBoxContainer/ResolutionDropdown
	
	if(err == OK and resolutionDrop):
		var resolutionSaved = config.get_value('video', 'resolution', 0)
		resolutionDrop.selected = resolutionSaved
		
		DisplayServer.window_set_size(resolutions[resolutionSaved])

func _on_resolution_selected(value):
	var currentSize = DisplayServer.window_get_size()
	if(currentSize != resolutions[value]):
		DisplayServer.window_set_size(resolutions[value])
	save_resolution_setting(value)

func save_resolution_setting(value):
	var config = ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value('video', 'resolution', value)
	config.save(CONFIG_PATH)

func _on_button_back_pressed() -> void:
	var main_menu_scene = load("res://scenes/core/MainMenu.tscn")
	var menu = main_menu_scene.instantiate()
	get_parent().add_child(menu)
	queue_free()
