extends Control

func _ready():
	$Title.modulate.a = 0
	$ThankYou.modulate.a = 0
	await get_tree().create_timer(1).timeout
	await get_tree().create_tween().tween_property($Title, "modulate:a", 1, 1).finished
	await get_tree().create_timer(1).timeout
	await get_tree().create_tween().tween_property($ThankYou, "modulate:a", 1, 1).finished
	await get_tree().create_timer(3).timeout
	get_tree().create_tween().tween_property($Title, "modulate:a", 0, 1)
	await get_tree().create_tween().tween_property($ThankYou, "modulate:a", 0, 1).finished
	await get_tree().create_timer(1).timeout
	get_tree().quit()
