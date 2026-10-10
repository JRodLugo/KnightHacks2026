extends Control

func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/TestScene/test_scene.tscn")

func _on_settings_button_down() -> void:
	$SettingsMenu.visible = true

func _on_quit_button_down() -> void:
	get_tree().quit()
