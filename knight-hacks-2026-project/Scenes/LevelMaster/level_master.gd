class_name LevelMaster extends Node2D

@export var levels: Array[LevelData]

var currentScene: Node2D
var currentSceneFile: PackedScene
var player: Player
var levelEntry: PackedScene = preload("res://Scenes/LevelMaster/level_entry.tscn")

func _ready():
	for level in levels:
		var newEntry = levelEntry.instantiate()
		newEntry.get_node("LevelTitle").set_text(level.level_name)
		newEntry.get_node("PlayLevel").button_down.connect(func(): switch(level.level_scene))
		$UI/LevelSelect/Entries/MarginContainer/VBoxContainer.add_child(newEntry)
	%SwipeAnim.play("swipe_out")
	

func restart():
	%SwipeAnim.play("swipe_in")
	await %SwipeAnim.animation_finished
	$UI/LevelSelect.visible = false
	if currentScene: currentScene.queue_free()
	currentScene = currentSceneFile.instantiate()
	add_child(currentScene)
	%SwipeAnim.play("swipe_out")
	
	player = currentScene.get_node("Player")
	player.get_node("Camera2D").make_current()
	$UI/DebugMenu.player = player
	player.get_node("Camera2D").make_current()
	player.restart_level.connect(restart)
	player.finish.connect(level_finish)

func switch(target: PackedScene):
	currentSceneFile = target
	restart()

func level_finish():
	get_tree().paused = true
	%LevelFinish.visible = true
	%LevelFinish.get_node("LimbsKept").set_text("Limbs kept:   " + str(get_player_limb_count()))
	%LevelFinish.get_node("NextLevel").grab_focus()
	%LFAnim.play("slide_in")

func _on_next_level_button_down() -> void:
	%LFAnim.play("RESET")
	%LFAnim.get_parent().visible = false
	get_tree().paused = false
	restart() # either I'm gonna set next level somewhere else or here but its this while we wait for levels
	
func get_player_limb_count():
	if not player: return # if no player is found, why are you here
	var limbCount: int = 0
	
	if player.get_node("LeftArmPivot").visible: limbCount += 1
	if player.get_node("RightArmPivot").visible: limbCount += 1
	if player.get_node("LeftLegPivot").visible: limbCount += 1
	if player.get_node("RightLegPivot").visible: limbCount += 1
	
	return limbCount
