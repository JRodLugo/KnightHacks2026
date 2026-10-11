## Stationary. Hisses when the player gets close.
## always deals contact damage (whether or not its hissing.)
## Contact damage reverses the player.
extends Enemy

var player_within_radius : bool;

func _ready():
	super();
	

func _on_col_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		player_within_radius = true;
		body.damaged.emit();
		# reverse player direction
		body.velocity = -body.velocity;
		body.scale.x = -body.scale.x;
		#TODO Damage the player again if they're still in the body

func _on_hiss_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		player_within_radius = false;
		turn_to_player(body)
		#start hissing
		%AnimationPlayer.play("chomper/idle-to-hiss")
		pass

func _on_hiss_radius_body_exited(body: Node2D) -> void:
	if body is Player:
		turn_to_player(body)
		#stop hissing
		%AnimationPlayer.play("chomper/idle")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	# link idle into hissing
	match anim_name:
		"chomper/idle-to-hiss":
			%AnimationPlayer.play("chomper/hissing");
		

func turn_to_player(player : Player):
	var player_directon := player.global_position.direction_to(global_position);
	if player_directon.x <= 0:
		sprite.flip_h = false;
	else:
		sprite.flip_h = true;
