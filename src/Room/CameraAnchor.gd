tool
extends Position2D
class_name CameraAnchor

const SCREEN_SIZE := Vector2(480, 270)

export (Color) var color = Color(255, 255, 255, 255)

var half_screen = SCREEN_SIZE / 2

onready var boundsNW := $BoundsNW
onready var boundsSE := $BoundsSE


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	if not Engine.editor_hint:
		return
	var low_point = -half_screen
	var hight_point = half_screen
	draw_line(low_point, Vector2(hight_point.x, low_point.y), color, 1)
	draw_line(Vector2(hight_point.x, low_point.y), hight_point, color, 1)
	draw_line(hight_point, Vector2(low_point.x, hight_point.y), color, 1)
	draw_line(Vector2(low_point.x, hight_point.y), low_point, color, 1)
	update()


func update_anchor_limit() -> void:
	RoomManager.bounds = {
		'limit_left': boundsNW.global_position.x,
		'limit_top': boundsNW.global_position.y,
		'limit_right': boundsSE.global_position.x,
		'limit_bottom': boundsSE.global_position.y,
	}
	Events.emit_signal("room_limit_changed", RoomManager.bounds)
