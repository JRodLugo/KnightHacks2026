class_name Player extends CharacterBody2D

signal restart_level
signal finish

const SPEED = 600.0
const JUMP_VELOCITY = -1000.0
const GRAVITY = 2500.0
const DE_ACCELERATION = 150.0

var limbVFX = preload("res://Player/limb_explosion.tscn")
var canMoveLeft: bool = true
var canMoveRight: bool = true
var jumpCharges: int = 2

func _unhandled_input(event):
	if event.is_action_pressed("left") and canMoveLeft:
		velocity.x = -1.0 * SPEED
		velocity.y = 0
		canMoveLeft = false
		scale.x = -1
		$LeftArmPivot.visible = false
		limb_explode($LeftArmPivot.global_position)
		%AnimationPlayer.play("walk")
	elif event.is_action_pressed("right") and canMoveRight:
		velocity.x = SPEED
		velocity.y = 0
		canMoveRight = false
		scale.x = 1
		$RightArmPivot.visible = false
		limb_explode($RightArmPivot.global_position)
		%AnimationPlayer.play("walk")
	
	elif event.is_action_pressed("pause"):
		finish.emit()
		return
		if get_tree().paused: return # it will try to re-pause if you use escape to resume
		$UI/PauseMenu.visible = true
		get_tree().paused = true

func _physics_process(delta: float) -> void:
	var grounded = is_on_floor()
	
	if not grounded:
		velocity += Vector2(0, GRAVITY) * delta

	if Input.is_action_just_pressed("jump") and jumpCharges > 0:
		velocity.y = JUMP_VELOCITY
		jumpCharges -= 1
		%AnimationPlayer.play("jump")
		
		# weird ternary to remove right then left sequentially, im sorry
		var selectedLeg = get_node(("Right" if jumpCharges == 1 else "Left") + "LegPivot")
		selectedLeg.visible = false
		limb_explode(selectedLeg.global_position)
		
		if jumpCharges == 0: $LegCollision.disabled = true
	
	if velocity.x != 0.0: # de-accel after moving
		velocity.x = move_toward(velocity.x, 0.0, delta * DE_ACCELERATION)
		%AnimationPlayer.speed_scale = abs(velocity.x / 500.0)
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
	
func limb_explode(given_position: Vector2):
	var newParticle = limbVFX.instantiate()
	add_child(newParticle)
	newParticle.global_position = given_position
	newParticle.restart()
	await newParticle.finished
	newParticle.queue_free()

#take damage
func takeDamage():
	if jumpCharges > 0:
		jumpCharges -= 1
		%AnimationPlayer.play("jump")
		
		# weird ternary to remove right then left sequentially, im sorry
		var selectedLeg = get_node(("Right" if jumpCharges == 1 else "Left") + "LegPivot")
		selectedLeg.visible = false
		limb_explode(selectedLeg.global_position)
		
		if jumpCharges == 0: $LegCollision.disabled = true
	elif canMoveLeft:
		canMoveLeft = false
		$LeftArmPivot.visible = false
		limb_explode($LeftArmPivot.global_position)
	elif canMoveRight:
		canMoveRight = false
		$RightArmPivot.visible = false
		limb_explode($RightArmPivot.global_position)
	
		
	
