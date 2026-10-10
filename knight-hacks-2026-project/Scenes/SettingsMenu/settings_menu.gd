extends Control

@export var prevContainer: Container

const RESOLUTIONS := [
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
]

func _ready():
	DisplayServer.window_set_size(Vector2i(1920, 1080))

func _on_close_button_down() -> void:
	visible = false
	for i in prevContainer.get_children():
		i.focus_mode = Control.FOCUS_ALL
		i.grab_focus()

func _on_resolution_item_selected(index: int) -> void:
	var new_size: Vector2i = RESOLUTIONS[index]

	# doesn't let you switch resolution if not windowed so yay
	var mode := DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	DisplayServer.window_set_size(new_size)
	DisplayServer.window_set_mode(mode)
	
func _on_display_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_max_fps_text_submitted(new_text: String) -> void:
	var newFPS = clampi(int(new_text), 30, 240)
	Engine.max_fps = newFPS
	$Main/VBoxContainer/MaxFPS/LineEdit.set_text(str(newFPS))

func _on_volume_drag_ended(value_changed: bool) -> void:
	if not value_changed: return
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db($Main/VBoxContainer/Volume/HSlider.value))
