extends Node2D

@export var prespawn : int = 2
@export var lane : int = 0
@export var is_left : bool = 0
@export var speed : int = 0
@export var timer : int = 5
@onready var prepack = preload("res://Placeables/Logs/Log.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = timer
	var size = get_viewport().get_visible_rect().size
	var rand = randi_range(0, size.x/prespawn)
	var variable = 0

	for index in prespawn:
		var logL
		logL = prepack.instantiate()
		logL = set_log(logL)
		logL.global_position.x = rand + variable
		get_parent().get_parent().get_node("Logs").call_deferred("add_child", logL)
		variable += size.x /prespawn


func _on_timer_timeout() -> void:
	var logL
	logL = prepack.instantiate()
	logL = set_log(logL)
	get_parent().get_parent().get_node('Logs').add_child(logL)

func set_log(logL):
	logL.is_left = is_left                            
	logL.speed = speed
	logL.global_position = global_position
	return logL
