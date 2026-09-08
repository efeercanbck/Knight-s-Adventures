extends Node2D

var dir=1
const SPEED=60
@onready var ray_cast_up: RayCast2D = $RayCastUP
@onready var ray_cast_down: RayCast2D = $RayCastDOWN


func _process(delta: float) -> void:
	if ray_cast_up.is_colliding():
		dir=1
	elif ray_cast_down.is_colliding():
		dir=-1
	position.y += SPEED * dir * delta
	
