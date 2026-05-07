extends Panel
func _ready():
	GameManager.game_over_signal.connect(_on_game_over)

func _on_game_over():
	self.show() # Paneli göster
	get_tree().paused = true # Oyunu dondur
