extends Node2D
class_name CarSpawner

# -----------------------------------
#            EXPORT VARIABLES
# -----------------------------------
@export var car_model: int = 0        # Indique le modèle de la voiture (0 à 4)
@export var go_left: bool = false # Direction du trafic (true = vers la gauche)
@export var car_speed: int = 0       # Vitesse des voitures
@export var timer: int = 5       # Intervalle de spawn automatique

# -----------------------------------
#       RESSOURCES PRÉ-CHARGÉES
# -----------------------------------
@onready var car_scene: PackedScene = preload("res://Placeables/Cars/car.tscn")
@onready var truck_scene: PackedScene = preload("res://Placeables/Cars/truck.tscn")


# -----------------------------------
#          INITIALISATION
# -----------------------------------
func _ready() -> void:
	# Configure le timer selon la valeur exportée
	$Timer.wait_time = timer

	# --- Distance entre voitures basée sur timer + speed ---
	var spacing := car_speed * timer

	# Génère 3 véhicules espacés sur la voie au début
	for i in range(1,4):
		var car := instantiate_car()

		# Décalage à gauche ou à droite selon la direction
		var offset := spacing * i

		if go_left:
			car.global_position.x = global_position.x - offset
		else:
			car.global_position.x = global_position.x + offset
			
		get_parent().get_parent().get_node("Cars").add_child(car)


# -----------------------------------
#     SPAWN AUTOMATIQUE (TIMER)
# -----------------------------------
func _on_timer_timeout() -> void:
	var car := instantiate_car()
	get_parent().get_parent().get_node("Cars").add_child(car)


# -----------------------------------
#  CRÉATION ET CONFIGURATION D'UN CAR
# -----------------------------------
func instantiate_car() -> Car:
	# Spawn d’un truck uniquement si le modèle est 4
	var car: Node
	if car_model == 4:
		car = truck_scene.instantiate()
	else:
		car = car_scene.instantiate()

	# Applique les propriétés du véhicule
	return set_car_properties(car)


# -----------------------------------
#     CONFIGURATION DU VÉHICULE
# -----------------------------------
func set_car_properties(car) -> Car:
	# Modèle (sprite) selon la lane
	if car_model == 4:
		car.model = 0
	else:
		car.model = car_model

	car.is_left = go_left
	car.speed = car_speed

	# Position de départ du spawner
	car.global_position = global_position

	return car
