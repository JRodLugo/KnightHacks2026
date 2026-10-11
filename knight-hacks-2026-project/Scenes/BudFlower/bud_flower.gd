extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.collect.emit()
		body.get_node("Squash").play()
		queue_free()
