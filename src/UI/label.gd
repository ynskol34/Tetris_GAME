extends Label
func _ready():
	GameManager.score_changed.connect(_on_score_updated)

func _on_score_updated(new_score):
	text = "Skor: " + str(new_score)
