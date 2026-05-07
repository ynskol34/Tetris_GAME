extends Node

var score = 0
var is_game_over = false

# Sinyaller kullanarak diğer scriptleri bilgilendirebilirsin
signal score_changed(new_score)
signal game_over

func start_game():
	score = 0
	is_game_over = false
	print("Oyun Başladı")
	emit_signal("score_changed", score)

func update_score(points):
	if is_game_over: return
	
	score += points
	print("Skor:", score)
	emit_signal("score_changed", score)

func set_game_over():
	if not is_game_over:
		is_game_over = true
		print("Game Over! Toplam Skor:", score)
		emit_signal("game_over")

# Tetris'te satır sayısına göre puanlama örneği
func add_line_score(lines_cleared: int):
	var points = 0
	match lines_cleared:
		1: points = 100
		2: points = 300
		3: points = 500
		4: points = 800
	
	update_score(points)
