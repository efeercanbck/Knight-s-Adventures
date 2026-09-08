extends Area2D


@export var monster: Node2D
@export var camera: Camera2D
@export var monster_animation_player: AnimationPlayer
@export var player:Node2D

func _on_body_entered(body: Node2D) -> void:
	var collision_shape=monster.get_node("aggro_area/CollisionShape2D")
	if body.is_in_group("players"):
		body.set_physics_process(false)
		monster.set_active(false)
		monster.visible=true
		var tween=create_tween()
		tween.tween_property(camera,"global_position",monster.global_position,1.0)
		await tween.finished
		monster_animation_player.play("entrance")
		await monster_animation_player.animation_finished
		monster.set_active(true)
		monster.SPEED = 165
		camera.reparent(player)
		camera.position= Vector2(0,-35)
		body.set_physics_process(true)
		collision_shape.shape=collision_shape.shape.duplicate()
		collision_shape.shape.radius=150
		queue_free()
		
