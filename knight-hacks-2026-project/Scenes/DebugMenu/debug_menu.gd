extends Control

@export var player: Player

func _input(event):
	if event.is_action_pressed("debug"):
		visible = not visible # flip visibility

func _on_reset_player_button_down() -> void:
	player.reset_player()

func _on_restart_level_button_down() -> void:
	player.restart_level.emit()

func _on_finish_level_button_down() -> void:
	player.finish.emit()
