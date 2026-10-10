extends Enemy

var move_speed;

var enemy_type;
var is_moving : bool;

func _ready() -> void:
	#region TEST
	nav_agent.target_position = self.position + Vector2(200,0);
	#endregion
	if self.col_shape:
		self.col_shape.shape = col_form;
	self.enemy_type = ENEMY_INDEX.Pace;

func _physics_process(delta: float) -> void:
	if (!nav_agent.is_target_reached()):
		is_moving = true;
		var next_pos = to_local(nav_agent.get_next_path_position());
		# normalize to allow velocity to depend on speed
		next_pos = next_pos.normalized();
		# commit to movement
		velocity = next_pos * move_speed * delta;
		
	else:
		is_moving = false;
		velocity = Vector2(); # stop moving

# When reaching the target
func _on_navigation_agent_2d_target_reached() -> void:
	print("Finished");
