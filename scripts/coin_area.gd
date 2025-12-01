extends CollisionShape2D

@export var coin_amount : int = 6
@export var lane_size : int = 5
@onready var prepack = preload('res://scenes/objects/Coin.tscn')
@onready var rect_shape = self.shape as RectangleShape2D

func _ready():
	randomize()
	var size_x = rect_shape.extents.x
	var size_y = rect_shape.extents.y/8
	
	for index in range(coin_amount):
		var coin = prepack.instantiate()
		
		var random_position_x = randf_range(-size_x, size_x)
		var random_position_y = randf_range(-lane_size, lane_size)
		coin.position = Vector2(random_position_x, random_position_y * size_y)

		get_parent().call_deferred("add_child", coin)
		
