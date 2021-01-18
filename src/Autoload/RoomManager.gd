# Keep in memory all params of a room
extends Node

enum Transition { horizontal, vertical, diagonal }

var to_load := ""
var room_name := ""
var gate_to_spawn := ""
var bounds := {}
var previous_anchor: CameraAnchor = null
var anchor: CameraAnchor = null setget set_anchor
var transition = Transition.horizontal


func set_anchor(new_anchor: CameraAnchor) -> void:
	previous_anchor = anchor
	anchor = new_anchor
