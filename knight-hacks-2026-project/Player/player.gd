class_name Player extends CharacterBody2D

const SPEED = 1000.0
const JUMP_VELOCITY = -1500.0
const GRAVITY = 2000.0
const DE_ACCELERATION = 200.0

var canMoveLeft: bool = true
var canMoveRight: bool = true
var jumpCharges: int = 2

func _input(event):
	if event.is_action_pressed("left") and canMoveLeft:
		velocity.x = -1.0 * SPEED
		velocity.y = 0
		canMoveLeft = false
		scale.x = -1
		$LeftArmPivot.visible = false
		%AnimationPlayer.play("walk")
	elif event.is_action_pressed("right") and canMoveRight:
		velocity.x = SPEED
		velocity.y = 0
		canMoveRight = false
		scale.x = 1
		$RightArmPivot.visible = false
		%AnimationPlayer.play("walk")

func _physics_process(delta: float) -> void:
	var grounded = is_on_floor()
	
	if not grounded:
		velocity += Vector2(0, GRAVITY) * delta

	if Input.is_action_just_pressed("jump") and jumpCharges > 0:
		velocity.y = JUMP_VELOCITY
		jumpCharges -= 1
		%AnimationPlayer.play("jump")
		
		# weird ternary to remove right then left sequentially, im sorry
		get_node(("Right" if jumpCharges == 1 else "Left") + "LegPivot").visible = false
		
		if jumpCharges == 0: $LegCollision.disabled = true
	
	if velocity.x != 0.0: # de-accel after moving
		velocity.x = move_toward(velocity.x, 0.0, delta * DE_ACCELERATION)
		%AnimationPlayer.speed_scale = velocity.normalized().x
	elif not %AnimationPlayer.current_animation == "idle" and not %AnimationPlayer.current_animation == "jump" and grounded:
		%AnimationPlayer.play("idle")

	move_and_slide()

func reset(): # call when doing a level transition yayyy (if we do implement)
	$RightArmPivot.visible = true
	$LeftArmPivot.visible = true
	$RightLegPivot.visible = true
	$LeftLegPivot.visible = true
	$LegCollision.disabled = false
	jumpCharges = 2
	canMoveLeft = true
	canMoveRight = true
