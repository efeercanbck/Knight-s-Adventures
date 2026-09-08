extends Control

@export var level_index: int
@onready var star_1: TextureRect = $TextureRect4
@onready var star_2: TextureRect = $TextureRect5
@onready var star_3: TextureRect = $TextureRect6




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_stars = LevelManager.stars.get(level_index,0)
	
	if my_stars>=1:
		star_1.visible=true
	if my_stars>=2:
		star_2.visible=true
	if my_stars>=3:
		star_3.visible=true
