class_name MovingPlatform extends StaticBody2D

@export var targetOffset: Vector2
@export var speed: float = 5.0
@export var linger_time: float = 5.0
@onready var startPosition: Vector2 = position

func _ready():
	while true:
		await get_tree().create_timer(linger_time).timeout
		await get_tree().create_tween().tween_property(self, "position", startPosition + targetOffset, speed).finished
		await get_tree().create_timer(linger_time).timeout
		await get_tree().create_tween().tween_property(self, "position", startPosition, speed).finished
