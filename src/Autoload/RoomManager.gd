# Keep in memory all params of a room
extends Node

var room_size := Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)
var to_load := ""
var bounds := {}
var previous_anchor: CameraAnchor = null
var anchor: CameraAnchor = null setget set_anchor
var is_anchor_locked := false


func set_anchor(new_anchor: CameraAnchor) -> void:
	previous_anchor = anchor
	anchor = new_anchor
