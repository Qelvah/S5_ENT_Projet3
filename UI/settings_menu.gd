extends Control

# -----------------------------------
#           VARIABLES & CONSTANTES
# -----------------------------------
const CONFIG_PATH := "user://settings.cfg"   		# Chemin du fichier de configuration
var SettingsMenu: Array[Variant] = []               # Liste des éléments navigables
var ButtonIndex: int = 0                         	# Index actuel dans le menu

var MusicStream                              		# AudioStreamPlayer pour la musique
var MusicList: Dictionary[Variant, Variant] = {}    # Dictionnaire des musiques

var SoundStream                              		# AudioStreamPlayer pour les sons UI
var SoundList: Dictionary[Variant, Variant] = {}    # Dictionnaire des effets sonores

var resolutions: Array[Variant] = [          # Résolutions disponibles
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920,1080)
]


# -----------------------------------
#           INITIALISATION
# -----------------------------------
func _ready():
	# Initialise le dropdown des résolutions
	var resolutionDropdown: OptionButton = $VBoxContainer/ResolutionDropdown
	resolutionDropdown.clear()
	for res in resolutions:
		resolutionDropdown.add_item("%dx%d" % [res.x, res.y])
		
	# Chargement des paramètres sauvegardés
	load_audio_setting()
	load_resolution_setting()
	load_fullscreen_setting()
	connect_signals()
	
	# Liste des widgets accessibles via ZQSD / flèches
	SettingsMenu = [
		$VBoxContainer/AudioSlider,
		$VBoxContainer/ResolutionDropdown,
		$VBoxContainer/FSCheck,
		$VBoxContainer/Button_Back
	]
	SettingsMenu[ButtonIndex].grab_focus()

	# Préparation de la musique
	MusicList["menu"] = preload("res://Resources/UI/BGM_Menu.mp3")
	MusicStream = $VBoxContainer/ASP_Music
	activateAudio("music", "menu")
	
	# Préparation des sons UI
	SoundStream = $VBoxContainer/ASP_Sound
	SoundList["click"] = preload("res://Resources/UI/Sounds/SFX_Click.wav")
	SoundList["move"]  = preload("res://Resources/UI/Sounds/SFX_Hover.mp3")


# -----------------------------------
#      NAVIGATION CLAVIER (INPUT)
# -----------------------------------
func _input(event):
	var resolutionDropdown: OptionButton = $VBoxContainer/ResolutionDropdown
	var audioSlider: HSlider = $VBoxContainer/AudioSlider
	var previousIndex: int = ButtonIndex
	
	if event is InputEventKey and event.pressed:

		# Navigation vers le haut
		if (event.keycode == KEY_W or event.keycode == KEY_UP) and ButtonIndex > 0:
			ButtonIndex -= 1

		# Navigation vers le bas
		elif (event.keycode == KEY_S or event.keycode == KEY_DOWN) and ButtonIndex < SettingsMenu.size() - 1:
			ButtonIndex += 1

		# Ajuste le volume quand le slider est sélectionné
		elif (event.keycode in [KEY_A, KEY_LEFT]) and ButtonIndex == 0:
			if audioSlider.value > 0:
				audioSlider.value -= 0.01

		elif (event.keycode in [KEY_D, KEY_RIGHT]) and ButtonIndex == 0:
			if audioSlider.value < 1:
				audioSlider.value += 0.01

		# Changer la résolution dans le dropdown
		elif (event.keycode in [KEY_A, KEY_LEFT]) and ButtonIndex == 1:
			if resolutionDropdown.selected > 0:
				resolutionDropdown.select(resolutionDropdown.selected - 1)
				DisplayServer.window_set_size(resolutions[resolutionDropdown.selected])

		elif (event.keycode in [KEY_D, KEY_RIGHT]) and ButtonIndex == 1:
			if resolutionDropdown.selected < resolutions.size() - 1:
				resolutionDropdown.select(resolutionDropdown.selected + 1)
				DisplayServer.window_set_size(resolutions[resolutionDropdown.selected])

		# Change le focus (joue un son)
		if previousIndex != ButtonIndex:
			SettingsMenu[ButtonIndex].grab_focus()
			activateAudio("sound", "move")

		# Active l’élément sélectionné
		if event.keycode in [KEY_F, KEY_ENTER]:
			SettingsMenu[ButtonIndex].emit_signal("pressed")

		# Retour menu précédent
		elif event.keycode == KEY_ESCAPE:
			_on_button_back_pressed()


# -----------------------------------
#      COMPORTEMENT AU SURVOL
# -----------------------------------
func _on_button_hovered(index):
	ButtonIndex = index
	SettingsMenu[ButtonIndex].grab_focus()
	activateAudio("sound", "move")


# -----------------------------------
#         GESTION DE L'AUDIO
# -----------------------------------
func activateAudio(type, key):
	# Joue une musique
	if type == "music":
		MusicStream.stream = MusicList[key]
		MusicStream.play()

	# Joue un son
	elif type == "sound":
		SoundStream.stream = SoundList[key]
		SoundStream.play()


# -----------------------------------
#     CONNEXION DES SIGNAUX UI
# -----------------------------------
func connect_signals():
	$VBoxContainer/AudioSlider.value_changed.connect(_on_audio_changed)
	$VBoxContainer/FSCheck.toggled.connect(_on_fullscreen_toggled)
	$VBoxContainer/ResolutionDropdown.item_selected.connect(_on_resolution_selected)


# -----------------------------------
#    CHARGEMENT / SAUVEGARDE AUDIO
# -----------------------------------
func load_audio_setting():
	var config: ConfigFile = ConfigFile.new()
	var err: int = config.load(CONFIG_PATH)
	var audioSlider: HSlider = $VBoxContainer/AudioSlider

	# Charge le volume existant, sinon valeur par défaut
	if err == OK and audioSlider:
		audioSlider.value = config.get_value("audio", "master_volume", 1.0)
	else:
		audioSlider.value = 1.0
		save_audio_setting(audioSlider.value)

func _on_audio_changed(value):
	# Convertit le slider (0 → 1) en décibels
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(value)
	)
	save_audio_setting(value)

func save_audio_setting(value):
	var config: ConfigFile = ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value("audio", "master_volume", float(value))
	config.save(CONFIG_PATH)


# -----------------------------------
#       MODE PLEIN ÉCRAN
# -----------------------------------
func load_fullscreen_setting():
	var config: ConfigFile = ConfigFile.new()
	var err: int = config.load(CONFIG_PATH)
	var FSCheck: CheckBox = $VBoxContainer/FSCheck
	
	if err == OK and FSCheck:
		FSCheck.button_pressed = config.get_value("video", "fullscreen", false)
	else:
		save_fullscreen_setting(FSCheck.button_pressed)

func _on_fullscreen_toggled(value):
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	save_fullscreen_setting(value)

func save_fullscreen_setting(value):
	var config: ConfigFile = ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value("video", "fullscreen", value)
	config.save(CONFIG_PATH)


# -----------------------------------
#        RÉSOLUTION ÉCRAN
# -----------------------------------
func load_resolution_setting():
	var config: ConfigFile = ConfigFile.new()
	var err: int = config.load(CONFIG_PATH)
	var resolutionDrop: OptionButton = $VBoxContainer/ResolutionDropdown
	
	if err == OK and resolutionDrop:
		var saved = config.get_value("video", "resolution", 0)
		resolutionDrop.selected = saved
		DisplayServer.window_set_size(resolutions[saved])

func _on_resolution_selected(value):
	# Change la taille si différente
	var currentSize: Vector2i = DisplayServer.window_get_size()
	if currentSize != resolutions[value]:
		DisplayServer.window_set_size(resolutions[value])
	save_resolution_setting(value)

func save_resolution_setting(value):
	var config: ConfigFile = ConfigFile.new()
	config.load(CONFIG_PATH)
	config.set_value("video", "resolution", value)
	config.save(CONFIG_PATH)


# -----------------------------------
#          RETOUR AU MENU
# -----------------------------------
func _on_button_back_pressed() -> void:
	var main_menu_scene: PackedScene = load("res://scenes/core/MainMenu.tscn")
	var menu: Node = main_menu_scene.instantiate()
	get_parent().add_child(menu)
	queue_free()
