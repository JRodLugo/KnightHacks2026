## Slowly moves toward the player.
## When colliding with the player, stop the player entirely.
extends Enemy

## How long the slug will wait after eating, before chasing again.
@export var downtime : float = 2.0;
## The slug's speed.
@export var movement_speed : float = 10.0;

var player_in_vision : bool = false;
var player_ref : Player;

func _ready():
	super();
	%AnimationPlayer.play("slug/idle");

func _physics_process(_delta: float) -> void:
	if player_in_vision && player_ref && $DownTime.time_left == 0:
		nav_agent.target_position = player_ref.global_position;
		turn_to_player(player_ref)
		var player_direction = player_ref.global_position.direction_to(global_position);
		if (player_direction.x <= 0):
			velocity.x = movement_speed;
		else:
			velocity.x = -movement_speed;
		move_and_slide();

func _on_vision_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_vision = true;
		turn_to_player(body);
		remember_player(body);
		%AnimationPlayer.play("slug/moving");
		body.global_position.direction_to(global_position);

func _on_vision_radius_body_exited(body: Node2D) -> void:
	if body is Player:
		# forget the player
		player_ref = null;
		player_in_vision = false;
		%AnimationPlayer.play("slug/idle");
		

func _on_col_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		turn_to_player(body);
		nav_agent.target_position = Vector2();
		%AnimationPlayer.play("slug/eating");
		$HELLO.play()
		body.damaged.emit();
		body.velocity = Vector2(0,0);
		print("nom");


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"slug/eating":
			$DownTime.start(downtime);

func turn_to_player(player : Player):
	var player_directon := player.global_position.direction_to(global_position);
	if player_directon.x <= 0:
		sprite.flip_h = false;
	else:
		sprite.flip_h = true;

## Keep a reference to the player while they're in view.
func remember_player(player : Player) -> void:
	player_ref = player;
