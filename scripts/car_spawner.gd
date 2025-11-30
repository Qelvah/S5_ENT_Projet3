extends Node2D

@export var lane : int = 0
@export var is_left : bool = 0
@export var speed : int = 0
@export var timer : int = 5
@onready var prepack = preload('res://scenes/objects/Car.tscn')
@onready var pretruck = preload("res://scenes/objects/Truck.tscn")


func _ready() :
	$Timer.wait_time = timer
	var size = get_viewport().get_visible_rect().size
	var rand = randi_range(0, size.x/3)
	var variable = 0

	for index in 3:
		var car
		if (lane == 4):
			car = pretruck.instantiate()
		else:
			car = prepack.instantiate()
		car = set_car(car)
		car.global_position.x = rand + variable
		get_parent().get_parent().get_node('Cars').add_child(car)
		variable += size.x /3

func _on_timer_timeout() -> void:
	var car
	if (lane == 4):
		car = pretruck.instantiate()
	else:
		car = prepack.instantiate()
	car = set_car(car)
	get_parent().get_parent().get_node('Cars').add_child(car)

func set_car(car):
	if (lane == 4):
		car.model = 0
	else:
		car.model = lane
	car.is_left = is_left                            
	car.speed = speed
	car.global_position = global_position
	return car
