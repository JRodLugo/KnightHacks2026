extends Area2D


func _on_body_entered(body):
	if body is Player:
		body.reset_player.call_deferred() # it wants call_deferred for some reason
	queue_free()
	
	
