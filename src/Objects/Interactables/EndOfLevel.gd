# Trigger end of level animatino and save player's data
extends Node2D
class_name EndOfLevel

enum Direction { RIGHT, LEFT, TOP, BOTTOM }

export (Direction) var direction := Direction.RIGHT

onready var _head = $Sign/Head


func _ready() -> void:
	$Area2D.connect("body_entered", self, "_on_body_entered")

	if not Engine.editor_hint:
		set_process(false)


func _process(delta: float) -> void:
	if not _head:
		return

	if direction == Direction.RIGHT:
		_head.scale.y = 1
		_head.scale.x = 1
		_head.rotation_degrees = 0
		_head.frame = 0
		return

	if direction == Direction.LEFT:
		_head.scale.y = 1
		_head.scale.x = -1
		_head.frame = 0
		return

	if direction == Direction.TOP:
		_head.scale.x = 1
		_head.scale.y = 1
		_head.frame = 1
		return

	if direction == Direction.BOTTOM:
		_head.scale.x = 1
		_head.scale.y = -1
		_head.frame = 1
		return


func _on_body_entered(body: Player) -> void:
	SceneManager.is_anchor_locked = true
	body.is_handling_input = false
	Events.emit_signal("level_finished")
