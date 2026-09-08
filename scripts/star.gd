extends Control
@onready var animation_player: AnimationPlayer = $TextureRect/AnimationPlayer

func fill():
	animation_player.play("add_star")
