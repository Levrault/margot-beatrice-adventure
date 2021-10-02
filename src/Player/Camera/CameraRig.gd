#Rig to move a child camera based on the player's input, to give them more forward visibility
extends Position2D

const TRANSITION_TIME := .475
const TRANSITION_TIME_DASH := .3

var is_active := true
var initial_position := Vector2.ZERO

onready var camera: Camera2D = $Camera
onready var _tween := $Tween


func _ready() -> void:
	_tween.connect("tween_all_completed", self, "_on_Tween_all_completed")
	initial_position = position


func transit_to_new_room() -> void:
	Events.emit_signal("room_transition_started")
	pause_mode = Node.PAUSE_MODE_PROCESS

	var previous_to_position = SceneManager.previous_anchor.global_position
	var to_position = SceneManager.anchor.global_position

	_tween.connect("tween_started", self, "_on_Tween_started")
	_tween.interpolate_property(
		self,
		"position",
		to_local(previous_to_position),
		to_local(to_position),
		TRANSITION_TIME if owner.state_machine.state_name != "Dash" else TRANSITION_TIME_DASH,
		Tween.TRANS_LINEAR,
		Tween.TRANS_LINEAR
	)
	_tween.start()


func _on_Tween_started(object: Object, key: NodePath) -> void:
	camera.limit_left = -10000000
	camera.limit_top = -10000000
	camera.limit_right = 10000000
	camera.limit_bottom = 10000000

	_tween.disconnect("tween_started", self, "_on_Tween_started")


func _on_Tween_all_completed() -> void:
	position = initial_position
	SceneManager.anchor.update_anchor_limit()
	owner.set_process(true)
	pause_mode = Node.PAUSE_MODE_INHERIT
	owner.is_handling_input = true
