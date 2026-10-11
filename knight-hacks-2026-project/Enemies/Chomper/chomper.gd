extends Enemy
# Stationary. Hisses when the player gets close
# always deals contact damage (whether or not its hissing.)

@export var hiss_radius : Shape2D;
func _ready():
	super();

func _physics_process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.damaged.emit();
		# Damage the player again if they're still in the body
