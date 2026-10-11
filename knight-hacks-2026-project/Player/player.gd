class_name Player extends CharacterBody2D

signal restart_level
signal finish # this is called from the finish flower, disregard warning
signal damaged # emitted by enemies.

const SPEED = 900.0
const JUMP_VELOCITY = -1600.0
const GRAVITY = 2500.0
const DE_ACCELERATION = 150.0

var limbVFX = preload("res://Player/limb_explosion.tscn")
var canMoveLeft: bool = true
var canMoveRight: bool = true
var dead: bool = false
var jumpCharges: int = 2
var inv_time : float = 1.0;

func _unhandled_input(event):
	if dead: return
	
	if event.is_action_pressed("left") and canMoveLeft:
		velocity.x = -1.0 * SPEED
		if velocity.y < 0:
			velocity.y = 100
		canMoveLeft = false
		rotation = 0
		scale = Vector2(-1, 1)
		$LeftArmPivot.visible = false
		limb_explode($LeftArmPivot.global_position)
		change_anim("walk")
	elif event.is_action_pressed("right") and canMoveRight:
		velocity.x = SPEED
		if velocity.y > 0:
			velocity.y = 100
			velocity.x=SPEED*1.4
		canMoveRight = false
		rotation = 0
		scale = Vector2(1, 1)
		$RightArmPivot.visible = false
		limb_explode($RightArmPivot.global_position)
		change_anim("walk")
	elif event.is_action_pressed("stop") and %Groundcast.get_collider():
		velocity.x = 0
		change_anim("idle")
	
	elif event.is_action_pressed("pause"):
		$UI/PauseMenu.visible = true
		$UI/PauseMenu/VBoxContainer/Resume.grab_focus()
		get_tree().paused = true

func _physics_process(delta: float) -> void:
	if dead: return
	
	var grounded = %Groundcast.get_collider()
	
	if not grounded:
		velocity += Vector2(0, GRAVITY) * delta
	else:
		if grounded is Conveyor:
			velocity.x = grounded.conveyorSpeed
		elif grounded is MovingPlatform and velocity.x == 0.0:
			global_position.x = grounded.global_position.x

	if Input.is_action_just_pressed("jump") and jumpCharges > 0:
		velocity.y = JUMP_VELOCITY
		jumpCharges -= 1
		change_anim("jump")
		grounded = false
		
		# weird ternary to remove right then left sequentially, im sorry
		var selectedLeg = get_node(("Right" if jumpCharges == 1 else "Left") + "LegPivot")
		selectedLeg.visible = false
		limb_explode(selectedLeg.global_position)
		
		if jumpCharges == 0: $LegCollision.disabled = true
	
	if velocity.x != 0.0:
		var colNormal = %Groundcast.get_collision_normal()
		var targetVelocity = 0.0 if (colNormal.y < -.9) else velocity.x * 3
		velocity.x = move_toward(velocity.x, targetVelocity, delta * DE_ACCELERATION)
		velocity.y += targetVelocity
		%AnimationPlayer.speed_scale = abs(velocity.x / 500.0)
		if grounded: change_anim("walk")
	else: # if velocity == 0
		if grounded:
			change_anim("idle")
			if not canMoveLeft and not canMoveRight and jumpCharges <= 0:
				dead = true
				await get_tree().create_timer(1).timeout
				kill()
	
	move_and_slide()

func change_anim(anim: String):
	%AnimationPlayer.play(anim)
	%MainSprite.play(anim)

func reset_player(): # no real use yet but we'll see
	$RightArmPivot.visible = true
	$LeftArmPivot.visible = true
	$RightLegPivot.visible = true
	$LeftLegPivot.visible = true
	$LegCollision.disabled = false
	jumpCharges = 2
	canMoveLeft = true
	canMoveRight = true

func kill():
	change_anim("death")
	await get_tree().create_timer(1).timeout
	restart_level.emit()
	
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
	else:
		kill()
	
# collide with enemies

func _on_damaged() -> void:
	takeDamage.call_deferred()
