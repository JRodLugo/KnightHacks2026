extends Area2D


func _on_body_entered(body):
	print("HELLOOO")
	if body.is_in_group("Player"):
		body.reset()
		print("Ultra")
	queue_free()
	
	
