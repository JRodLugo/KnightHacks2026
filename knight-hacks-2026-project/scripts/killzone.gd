extends Area2D


#when player enters the kill zone
func _on_body_entered(body):
	print("Somthing passed through")
	#kill player
	if body is Player:
		print("KILLED PLAYER")
		body.kill()
		
		
	
