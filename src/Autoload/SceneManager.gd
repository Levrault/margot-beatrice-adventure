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
var tilemap: TileMap = null


func set_anchor(new_anchor: CameraAnchor) -> void:
	previous_anchor = anchor
	anchor = new_anchor


func is_on_screen(object_position: Vector2) -> bool:
	if object_position.y > bounds.limit_bottom:
		return false
	if object_position.y < bounds.limit_top:
		return false
	if object_position.x < bounds.limit_left:
		return false
	if object_position.x > bounds.limit_right:
		return false
	return true
