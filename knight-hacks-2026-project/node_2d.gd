extends Enemy
# Enemy that walks back and forth along set positions.

## The enemy's speed.
@export var move_speed : int = 1000;
## How long (in seconds) will the enemy wait to move again?
@export var cooldown_time : int = 2;

@export var enemy_positions : Array[Vector2];

## index number of this enemy type
var enemy_type : int;

var is_moving : bool = false;
## Is the enemy moving backwards (in terms of array positions?)
var is_backtracking : bool = false;
## How many positions will this Enemy go to?
var position_count : int;

@onready var wait_time : Timer = $WaitTime;

func _ready() -> void:
	#region TEST
	#cur_goal_pos = self.global_position + Vector2(200,0)
	#nav_agent.target_position = cur_goal_pos;
	#endregion
	# Initializing
	self.enemy_type = ENEMY_INDEX.Pace;
	wait_time.one_shot = true;
	if self.col_shape:
		self.col_shape.shape = col_form;
	
	#print("First Target: " + str(nav_agent.target_position));
	
	

func _physics_process(delta: float) -> void:
	if (!nav_agent.is_target_reached()):
		is_moving = true;
		var next_pos = to_local(nav_agent.get_next_path_position());
		next_pos = next_pos.normalized();
		print(next_pos)
		# commit to movement
		velocity = next_pos * move_speed * delta;
		move_and_slide();
	else:
		is_moving = false;
		velocity = Vector2(); # stop moving

## Get the position of this Enemy's next goal.
func get_next_goal() -> Vector2:
	return Vector2(); # placeholder

# When reaching the target
func _on_navigation_agent_2d_target_reached() -> void:
	print("Finished");
	wait_time.start(cooldown_time);

func _on_wait_time_timeout() -> void:
	print("Start moving");
	#region TEST
	#cur_goal_pos = self.global_position + Vector2(200,0);
	#nav_agent.target_position = cur_goal_pos;
	#endregion
	#cur_goal = get_goal();
