extends Node2D

@onready var grid_node = $Grid 

var shapes = [
	preload("res://src/modules/tetromino/tshape.gd"),
	preload("res://src/modules/tetromino/lshape.gd"),
	preload("res://src/modules/tetromino/ishape.gd")
]

func _ready():
	randomize() # Her açılışta farklı blok sırası
	spawn_new_block()

func spawn_new_block():
	if GameManager.is_game_over: return
	
	
	var shape_script = shapes[randi() % shapes.size()]
	var new_block = shape_script.new()
	new_block.grid = grid_node
	
	# Spawn noktasında direkt çarpışma varsa OYUN BİTTİ
	if grid_node.check_collision(new_block.grid_position, new_block.shape):
		GameManager.set_game_over()
		new_block.queue_free()
	else:
		add_child(new_block)
