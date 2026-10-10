extends Area2D


func _on_body_entered(body):
	print("HELLOOO")
	if body is Player:
		body.reset_player()
		print("Ultra")
	queue_free()
	
	
