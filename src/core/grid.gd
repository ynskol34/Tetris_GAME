extends Node2D

var width = 36
var height = 21
var grid_data = [] 
var block_size = 50

func _ready():
	create_grid()

func create_grid():
	grid_data = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(null) # Boş hücreler null (renksiz)
		grid_data.append(row)

func is_inside(x: int, y: int) -> bool:
	return x >= 0 and x < width and y >= 0 and y < height

func check_collision(pos: Vector2i, shape: Array) -> bool:
	for y in range(shape.size()):
		for x in range(shape[y].size()):
			if shape[y][x] == 1:
				var target_x = pos.x + x
				var target_y = pos.y + y
				if not is_inside(target_x, target_y) or grid_data[target_y][target_x] != null:
					return true
	return false

# Tetromino artık rengini buraya teslim ediyor
func place_shape(pos: Vector2i, shape: Array, color: Color):
	for y in range(shape.size()):
		for x in range(shape[y].size()):
			if shape[y][x] == 1:
				var gx = pos.x + x
				var gy = pos.y + y
				if is_inside(gx, gy):
					grid_data[gy][gx] = color # Rengi hücreye işle
	
	check_and_clear_lines() # Satırları kontrol et ve sil
	queue_redraw()

func check_and_clear_lines():
	var lines_cleared = 0
	var y = height - 1
	while y >= 0:
		var is_full = true
		for x in range(width):
			if grid_data[y][x] == null:
				is_full = false
				break
		
		if is_full:
			grid_data.remove_at(y)
			var new_row = []
			for i in range(width): new_row.append(null)
			grid_data.insert(0, new_row)
			lines_cleared += 1
			# Satırı silince y'yi değiştirmiyoruz ki yeni gelen satırı da kontrol edelim
		else:
			y -= 1
	
	if lines_cleared > 0:
		GameManager.add_line_score(lines_cleared)

func _draw():
	for y in range(height):
		for x in range(width):
			var rect = Rect2(x * block_size, y * block_size, block_size, block_size)
			if grid_data[y][x] != null:
				draw_rect(rect, grid_data[y][x]) # Hücrenin kendi rengini çiz
			draw_rect(rect, Color(0.887, 0.0, 0.388, 1.0), false, 1.0) # Izgara çizgileri
