extends Node

# Oyun değişkenleri
var score = 0
var is_game_over = false

# Sinyaller (UI ve Diğer sahnelerle haberleşmek için)
signal score_changed(new_score)
signal game_over_signal # 'game_over' ismi bazen karışıklık yaratabilir, 'game_over_signal' yaptık

# Skor ekleme fonksiyonu
func add_line_score(lines_cleared: int):
	if is_game_over: return
	
	var points = 0
	# Satır sayısına göre kombo puanları
	match lines_cleared:
		1: points = 100
		2: points = 300
		3: points = 500
		4: points = 800
	
	score += points
	# UI'ya puanın değiştiğini haber ver
	emit_signal("score_changed", score)
	print("Satır Silindi: ", lines_cleared, " | Toplam Skor: ", score)

# Oyun bittiğinde çağrılacak fonksiyon
func set_game_over():
	if not is_game_over:
		is_game_over = true
		emit_signal("game_over_signal")
		print("GAME OVER! Final Skor: ", score)

# Oyunu tamamen sıfırlamak için (Restart butonu için)
func reset_game():
	score = 0
	is_game_over = false
	# Sahneyi yeniden yüklüyoruz
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_button_pressed() -> void:
	pass # Replace with function body.


#Zamanlayıcı için Değişkenler
@onready var game_timer = $"/root/Main/GameTimer" # Sahnenin olduğu yapı yolunu kopyalıyoruz. Sahne kod ile birleşsin.
@onready var timer_label = $"/root/Main/UI/TimerLabel # Yine aynı şekilde kopyalıyoruz.

var total_time : int= 0 # Geçen toplam saniye 0 olarak ayarlanıyor.

func _on_game_timer_timeout() -> void:
    total_time +=1
    update_timer_label()

# Zamanı dakika saniye formatına çeviren fonksiyon
func update_timer_label() -> void:
    var minutes = total_time / 60
    var seconds = total_time % 60 
# Örnek: 02:05 şeklinde gözükmesi için string formatı kullanıyoruz.
timer_label.text = "Süre: %02d:%02d" % [minutes, seconds]
