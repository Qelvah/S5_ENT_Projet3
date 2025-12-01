extends Node2D

# -----------------------------------
#           VARIABLES & CONSTANTES
# -----------------------------------
const CONFIG_PATH := "user://settings.cfg"           # Chemin du fichier de configuration sauvegardée

# Résolutions disponibles dans le dropdown
var resolutions: Array[Variant] = [
	Vector2i(256, 256),
	Vector2i(338, 338),
	Vector2i(420, 420)
]


# -----------------------------------
#           INITIALISATION
# -----------------------------------

func _ready() -> void:
	# Charge toutes les options sauvegardées (audio / vidéo)
	load_settings()


# -------------------------------------------------
#      CHARGEMENT DES PARAMÈTRES UTILISATEUR
# -------------------------------------------------
func load_settings():
	load_audio_setting()
	load_fullscreen_setting()
	load_resolution_setting()


# -------------------------------------------------
#       CHARGEMENT PARAMÈTRE : AUDIO
# -------------------------------------------------
func load_audio_setting():
	var config: ConfigFile = ConfigFile.new()
	var err: int = config.load(CONFIG_PATH)

	if err == OK:
		# Récupère le volume ou 1.0 par défaut
		var volume = config.get_value("audio", "master_volume", 1.0)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			linear_to_db(volume)
		)


# -------------------------------------------------
#      CHARGEMENT PARAMÈTRE : FULLSCREEN
# -------------------------------------------------
func load_fullscreen_setting():
	var config: ConfigFile = ConfigFile.new()
	var err: int = config.load(CONFIG_PATH)

	if err == OK:
		var fullscreen = config.get_value("video", "fullscreen", false)

		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)


# -------------------------------------------------
#     CHARGEMENT PARAMÈTRE : RÉSOLUTION
# -------------------------------------------------
func load_resolution_setting():
	var config: ConfigFile = ConfigFile.new()
	var err: int = config.load(CONFIG_PATH)

	if err == OK:
		var resolutionSaved = config.get_value("video", "resolution", 0)
		DisplayServer.window_set_size(resolutions[resolutionSaved])
