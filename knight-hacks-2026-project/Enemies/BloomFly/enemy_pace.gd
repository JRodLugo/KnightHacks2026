extends Enemy
# Enemy that walks back and forth along set positions.

const DEFAULT_SPEED : float = 10.0;
const DEFAULT_COOLDOWN : float= 2.0;
## Use a default collision form if there is none provided.
const FALLBACK_COL = preload("uid://bniw2nisdptks")
## The enemy's speed.
@export var move_speed : float = DEFAULT_SPEED;
## How long (in seconds) will the enemy wait to move again?
@export var cooldown_time : float = DEFAULT_COOLDOWN;

# Assume the enemy's first "position" is its starting global position.
@export var enemy_positions : Array[Vector2];
@export var anim_player : AnimationPlayer;

## Unique Index number of this enemy type.
var enemy_type : int;
## Is the enemy currently moving between points?
var is_moving : bool = false;
## Is the enemy moving backwards (in terms of array positions?)
var is_backtracking : bool = false;
## The amount of positions the enemies can move to. MUST be at least 2.
var position_count : int;
## Where in the position array is the enemy moving to?
var position_index : int = 0;

@export var wait_time : Timer;



func _ready() -> void:
	#print(global_position)
	# Initializing
	self.enemy_type = ENEMY_INDEX.Pace;
	self.wait_time.one_shot = true;
	self.position_count = enemy_positions.size();
	self.col_form = self.col_shape.shape
	#self.nav_agent.max_speed = move_speed;
	# Use fallback collision form if it doesn't exist.
	if !self.col_form: 
		push_warning("No collision form for Enemy Node " + self.name + "! Using fallback shape.");
		col_form = FALLBACK_COL;
	
	
	# CRITICAL: ALL Pacing enemies should have at least 1 target defined.
	assert((position_count > 0), "Pacing enemies must have at least 1 target vector set!");
	
	# Move starting position to front
	enemy_positions.push_front(self.global_position);

	#print(enemy_positions)
	
	position_index = next_goal(self.position_index);

func _physics_process(delta: float) -> void:
	movement_handler(delta);
	

func movement_handler(delta) -> void:
	if (!nav_agent.is_target_reached()):
		is_moving = true;
		var next_pos : Vector2 = to_local(nav_agent.get_next_path_position());
		next_pos = next_pos.normalized();
		var dist_to_target : float = global_position.distance_to(enemy_positions[position_index]);
		
		
		if dist_to_target < 100: # slow down if approaching target
			velocity = velocity.lerp(next_pos, delta);
		else:
			# * 5 to make movespeed export numbers nicer
			velocity = next_pos * (move_speed*5);
		
		
		
		# commit to movement
		move_and_slide();
		
		anim_player.play("bloomfly/moving");
		# flip sprite based on direction
		if (abs(velocity.x) != velocity.x):
			sprite.flip_h = true;
		else:
			sprite.flip_h = false;
	else:
		is_moving = false;
		anim_player.play("bloomfly/idle");
		velocity = Vector2(); # stop moving immediately

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
	#print("Next index: "  + str(next_index))
	nav_agent.target_position = enemy_positions[next_index];
	return next_index;

# When reaching the target
func _on_navigation_agent_2d_target_reached() -> void:
	print("Finished");
	wait_time.start(cooldown_time);

func _on_wait_time_timeout() -> void:
	print("Start moving");
	position_index = next_goal(position_index);
