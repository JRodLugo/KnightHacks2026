extends Control

func _on_back_to_menu_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")

func _on_settings_button_down() -> void:
	$SettingsMenu.visible = true

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_resume_button_down() -> void:
	get_tree().paused = false
	visible = false
