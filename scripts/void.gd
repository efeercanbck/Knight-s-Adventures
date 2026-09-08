extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		if body.has_method("die"):
			var camera=body.get_node_or_null("Camera2D")
			if camera:
				var son_konum=camera.global_position
				camera.top_level=true
				camera.global_position = son_konum
			body.die()
	if body.is_in_group("mob"):
		body.queue_free()
