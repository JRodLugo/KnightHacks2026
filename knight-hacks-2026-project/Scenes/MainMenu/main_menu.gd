extends Control

func _ready():
	$VBoxContainer/Play.grab_focus()

func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelMaster/level_master.tscn")

func _on_settings_button_down() -> void:
	for i in $VBoxContainer.get_children():
		i.focus_mode = Control.FOCUS_NONE
	$SettingsMenu.get_node("Main/VBoxContainer/Resolution/OptionButton").grab_focus()
	$SettingsMenu.visible = true

func _on_quit_button_down() -> void:
	get_tree().quit()
