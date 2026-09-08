extends CanvasLayer

signal closed
@onready var star_1: Control = $Control/star
@onready var star_2: Control = $Control/star2
@onready var star_3: Control = $Control/star3

@onready var message: Label = $Message
@onready var timer: Timer = $Timer



func show_results(stars: int):
	if stars >= 1:
		star_1.fill()
		await get_tree().create_timer(0.4).timeout
	if stars >=2:
		star_2.fill()
		await  get_tree().create_timer(0.4).timeout
	if stars >=3:
		star_3.fill()
		await get_tree().create_timer(0.3).timeout
	if stars==0:
		message.visible=true
	timer.start()

func _on_timer_timeout() -> void:
	closed.emit()
	queue_free()
