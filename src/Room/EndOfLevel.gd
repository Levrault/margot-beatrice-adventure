# Trigger end of level animatino and save player's data
tool
extends Node2D
class_name EndOfLevel

enum Direction { right, left, top, bottom }

export (Direction) var direction := Direction.right

onready var _head = $Sign/Head


func _ready() -> void:
	Events.connect("game_saved", self, "_on_Saved_successfull")
	$Area2D.connect("body_entered", self, "_on_body_entered")

	if not Engine.editor_hint:
		set_process(false)


func _process(delta: float) -> void:
	if direction == Direction.right:
		_head.scale.y = 1
		_head.scale.x = 1
		_head.rotation_degrees = 0
		_head.frame = 0
		return

	if direction == Direction.left:
		_head.scale.y = 1
		_head.scale.x = -1
		_head.frame = 0
		return

	if direction == Direction.top:
		_head.scale.x = 1
		_head.scale.y = 1
		_head.frame = 1
		return

	if direction == Direction.bottom:
		_head.scale.x = 1
		_head.scale.y = -1
		_head.frame = 1
		return


func _on_Saved_successfull() -> void:
	print("in")


func _on_body_entered(body: Player) -> void:
	RoomManager.is_anchor_locked = true
	body.is_handling_input = false
	Events.emit_signal("level_finished")
