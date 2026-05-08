extends Node2D
class_name Tetromino

var shape = []
var grid_position = Vector2i(18, 0) # öncesinde (6,0) ve sonrasında (8,0) olan x(satır) sayısı grid.gd'de 36 yapılarak grid position 18 e dönüştürüldü ve sonrasında bloklar ortada spawn olmaya başladı.
var block_size = 50
var fall_speed = 0.8 # 0.5 olan düşme hızı, 0.8 yapılarak düşme hızı yavaşlatıldı.
var fall_timer = 0.0
var grid = null 
var block_color = Color.WHITE

func _process(delta: float):
	# BURADA HATA YOK: GameManager ve grid kontrolü zaten var.
	if grid == null or shape.is_empty() or GameManager.is_game_over: return
	
	fall_timer += delta
	if fall_timer >= fall_speed:
		fall_timer = 0.0
		move_down()

func move(direction: Vector2i):
	# HATA DÜZELTME 1: grid kontrolü eklendi.
	if grid == null: return 
	
	var new_pos = grid_position + direction
	if not grid.check_collision(new_pos, shape):
		grid_position = new_pos
		queue_redraw()

func move_down():
	# HATA DÜZELTME 2: 'Invalid call on base Nil' hatasını burası veriyordu.
	# Çünkü grid atanmadan tuşa basarsan grid.check_collision çöker.
	if grid == null: return 
	
	var new_pos = grid_position + Vector2i(0, 1)
	if not grid.check_collision(new_pos, shape):
		grid_position = new_pos
		queue_redraw()
	else:
		lock_and_spawn()

func lock_and_spawn():
	# HATA DÜZELTME 3: grid kontrolü eklendi.
	if grid == null: return
	
	grid.place_shape(grid_position, shape, block_color)
	queue_free()
	if get_parent().has_method("spawn_new_block"):
		get_parent().spawn_new_block()

func rotate_shape():
	# HATA DÜZELTME 4: grid ve shape kontrolü eklendi.
	if grid == null or shape.is_empty(): return
	
	var new_shape = []
	for x in range(shape[0].size()):
		var row = []
		for y in range(shape.size() - 1, -1, -1):
			row.append(shape[y][x])
		new_shape.append(row)
	
	if not grid.check_collision(grid_position, new_shape):
		shape = new_shape
		queue_redraw()

func _draw():
	# BURADA HATA YOK: Sadece görsel çizim yapıyor.
	if shape.is_empty(): return
	for y in range(shape.size()):
		for x in range(shape[y].size()):
			if shape[y][x] == 1:
				var draw_pos = Vector2((grid_position.x + x) * block_size, (grid_position.y + y) * block_size)
				draw_rect(Rect2(draw_pos, Vector2(block_size, block_size)), block_color)
				draw_rect(Rect2(draw_pos, Vector2(block_size, block_size)), Color.BLACK, false, 1.0)

func _input(event):
	# BURADA HATA YOK: Ama üstteki move/move_down içindeki kontroller hayat kurtarır.
	if GameManager.is_game_over: return
	if event.is_action_pressed("ui_left"): move(Vector2i(-1, 0))
	elif event.is_action_pressed("ui_right"): move(Vector2i(1, 0))
	elif event.is_action_pressed("ui_down"): move_down()
	elif event.is_action_pressed("ui_up"): rotate_shape()
