extends Enemy
# Enemy that walks back and forth along set positions.

## The enemy's speed.
@export var move_speed : int = 1000;
## How long (in seconds) will the enemy wait to move again?
@export var cooldown_time : int = 2;

# Assume the enemy's first "position" is its starting global position.
@export var enemy_positions : Array[Vector2];

## index number of this enemy type
var enemy_type : int;

var is_moving : bool = false;
## Is the enemy moving backwards (in terms of array positions?)
var is_backtracking : bool = false;
## How many positions will this Enemy go to? MUST be at least 2.
var position_count : int;
#
var position_index : int;

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
	self.position_count = enemy_positions.size();
	
	# CRITICAL: ALL Pacing enemies should have at least 1 target defined.
	assert((position_count > 0), "Pacing enemies must have at least 1 target vector set!");
	
	# Move starting position to front
	enemy_positions.push_front(self.global_position);

	self.position_index = 0;
	print(enemy_positions)
	
	position_index = next_goal(self.position_index);
	#get_next_goal(self.position_index);

func _physics_process(delta: float) -> void:
	if (!nav_agent.is_target_reached()):
		is_moving = true;
		var next_pos = to_local(nav_agent.get_next_path_position());
		next_pos = next_pos.normalized();
		#print(next_pos)
		# commit to movement
		velocity = next_pos * move_speed * delta;
		move_and_slide();
	else:
		is_moving = false;
		velocity = Vector2(); # stop moving

## Set the position of this Enemy's next goal.
## Returns the next index in the position array.
func next_goal(cur_index) -> int:
	var next_index;
	
	# end of the array (moving forward)
	if (enemy_positions[cur_index] == enemy_positions[-1] && !is_backtracking):
		is_backtracking = true;
		next_index = cur_index - 1;
	# start of the array (moving backward)
	elif (enemy_positions[cur_index] == enemy_positions[0] && is_backtracking):
		is_backtracking = false;
		next_index = cur_index + 1;
	else:
		if (!is_backtracking): # moving forward
			next_index = cur_index + 1;
		if (is_backtracking): # moving backward
			next_index = cur_index - 1;
	print("Next index: "  + str(next_index))
	nav_agent.target_position = enemy_positions[next_index];
	return next_index;

# When reaching the target
func _on_navigation_agent_2d_target_reached() -> void:
	print("Finished");
	wait_time.start(cooldown_time);

func _on_wait_time_timeout() -> void:
	print("Start moving");
	position_index = next_goal(position_index);
	#region TEST
	#cur_goal_pos = self.global_position + Vector2(200,0);
	#nav_agent.target_position = cur_goal_pos;
	#endregion
	#cur_goal = get_goal();
