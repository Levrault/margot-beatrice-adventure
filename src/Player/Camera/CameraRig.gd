#Rig to move a child camera based on the player's input, to give them more forward visibility
extends Position2D

var is_active := true
var initial_position := Vector2.ZERO

onready var camera: Camera2D = $Camera
onready var _tween := $Tween


func _ready() -> void:
	_tween.connect("tween_all_completed", self, "_on_Tween_all_completed")
	initial_position = position


func transit_to_new_room() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	var transition_time := .475
	if owner.state_machine.state_name == "Dash":
		transition_time = .3

	_tween.connect("tween_started", self, "_on_Tween_started")
	_tween.interpolate_property(
		self,
		"position",
		to_local(RoomManager.previous_anchor.global_position),
		to_local(RoomManager.anchor.global_position),
		transition_time,
		Tween.TRANS_LINEAR,
		Tween.TRANS_LINEAR
	)
	_tween.start()


func _on_Tween_started(object: Object, key: NodePath) -> void:
	if RoomManager.transition == RoomManager.Transition.horizontal:
		camera.limit_left = -10000000
		camera.limit_right = 10000000
	elif RoomManager.transition == RoomManager.Transition.vertical:
		camera.limit_top = -10000000
		camera.limit_bottom = 10000000
	else:
		camera.limit_left = -10000000
		camera.limit_top = -10000000
		camera.limit_right = 10000000
		camera.limit_bottom = 10000000

	_tween.disconnect("tween_started", self, "_on_Tween_started")


func _on_Tween_all_completed() -> void:
	position = initial_position
	RoomManager.anchor.update_anchor_limit()
	get_tree().paused = false
	owner.set_process(true)
	pause_mode = Node.PAUSE_MODE_INHERIT
	owner.is_handling_input = true
