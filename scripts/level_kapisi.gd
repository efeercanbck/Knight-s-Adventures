extends Area2D #level_kapisi

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2


@export var level_index: int
var player_in_range=false
var is_unlocked=false

#LevelManager'dan veri çekeceğiz
#Buna göre _Ready() fonksiyonunda ya açık ya da kapalı kapıyı göreceğiz
func _ready() -> void:
	is_unlocked = LevelManager.is_level_unlocked(level_index)
	if is_unlocked:
		sprite_2d_2.visible=false
	else:
		sprite_2d_2.visible=true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		player_in_range=true
		sprite_2d.visible=true



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		player_in_range=false
		sprite_2d.visible=false



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range and is_unlocked:
		print("Karakter tuşa bastı")
		LevelManager.go_to_level(level_index)
	
	elif event.is_action_pressed("interact") and is_unlocked==false and player_in_range:
		print("kilitli")
		
