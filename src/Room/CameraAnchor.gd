# If the room fit the screen size
#	Root position 2d is used to made the transition
# If the room is bigger, 
#	both east and west entrance are placed to be used in the transition
tool
extends Position2D
class_name CameraAnchor

enum DISPOSITION { horizontal, vertical, manual }
export (DISPOSITION) var disposition = DISPOSITION.horizontal

export var screen_size: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)

var initial_screen_size := Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)

export (Color) var color = Color(255, 255, 255, 255)

onready var boundsNW := $BoundsNW
onready var boundsSE := $BoundsSE
onready var north_or_east_anchor := $NorthOrEastAnchor
onready var south_or_west_anchor := $SouthOrWestAnchor


func _process(delta: float) -> void:
	update()

	boundsNW.position = Vector2(-screen_size.x / 2, -screen_size.y / 2)
	boundsSE.position = Vector2(screen_size.x / 2, screen_size.y / 2)

	if disposition == DISPOSITION.horizontal:
		north_or_east_anchor.position = Vector2(-screen_size.x / 2 + initial_screen_size.x / 2, 0)
		south_or_west_anchor.position = Vector2(screen_size.x / 2 - initial_screen_size.x / 2, 0)
		return

	if disposition == DISPOSITION.vertical:
		north_or_east_anchor.position = Vector2(0, -screen_size.y / 2 + initial_screen_size.y / 2)
		south_or_west_anchor.position = Vector2(0, screen_size.y / 2 - initial_screen_size.y / 2)
		return


func _draw() -> void:
	if not Engine.editor_hint:
		return
	var half_screen = screen_size / 2
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


func is_viewport_sized() -> bool:
	return initial_screen_size == screen_size


func get_nearest_entrance_distance(position: Vector2) -> Vector2:
	var east_distance = north_or_east_anchor.global_position.distance_to(position)
	var west_distance = south_or_west_anchor.global_position.distance_to(position)
	if east_distance < west_distance:
		return east_distance
	return west_distance


func get_nearest_entrance_position(position: Vector2) -> Vector2:
	if (
		north_or_east_anchor.position.distance_to(position)
		< south_or_west_anchor.position.distance_to(position)
	):
		return north_or_east_anchor.global_position

	return south_or_west_anchor.global_position
