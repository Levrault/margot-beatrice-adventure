# If the room fit the screen size
#	Root position 2d is used to made the transition
# If the room is bigger,
#	both east and west entrance are placed to be used in the transition
tool
extends Position2D
class_name CameraAnchor

const AXES := ["N", "S", "E", "W", "NW", "NE", "SW", "SE"]

export var screen_size: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)
export (Color) var color = Color(255, 255, 255, 255)

var entrance_anchor_scene := preload("res://src/Room/EntranceAnchor.tscn")
var initial_screen_size := Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)

var entrances := []

onready var boundsNW := $BoundsNW
onready var boundsSE := $BoundsSE


func _ready() -> void:
	if not is_viewport_sized():
		_set_entrances_position()

	# custom entrances
	for child in get_children():
		if child.is_in_group("room_entrance"):
			entrances.append(child)


	boundsNW.position = Vector2(-screen_size.x / 2, -screen_size.y / 2)
	boundsSE.position = Vector2(screen_size.x / 2, screen_size.y / 2)


func _process(delta: float) -> void:
	update()
	boundsNW.position = Vector2(-screen_size.x / 2, -screen_size.y / 2)
	boundsSE.position = Vector2(screen_size.x / 2, screen_size.y / 2)


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


func get_nearest_entrance(position: Vector2) -> Position2D:
	if entrances.empty():
		return self

	var nearest_entrance = entrances[0]

	for entrance in entrances:
		if (
			entrance.position.distance_to(to_local(position))
			< nearest_entrance.position.distance_to(to_local(position))
		):
			nearest_entrance = entrance

	return nearest_entrance


func _set_entrances_position() -> void:
	# automatic script to create and set position of entrance
	for i in AXES:
		var entrance_anchor := entrance_anchor_scene.instance()
		entrance_anchor.name = "entrance_anchor_%s" % [i]
		add_child(entrance_anchor)
		entrances.append(entrance_anchor)

	# North
	entrances[0].position = Vector2(0, -screen_size.y / 2 + initial_screen_size.y / 2)
	# South
	entrances[1].position = Vector2(0, screen_size.y / 2 - initial_screen_size.y / 2)
	# West
	entrances[2].position = Vector2(-screen_size.x / 2 + initial_screen_size.x / 2, 0)
	# East
	entrances[3].position = Vector2(screen_size.x / 2 - initial_screen_size.x / 2, 0)
	# North-West
	entrances[4].position = Vector2(
		-screen_size.x / 2 + initial_screen_size.x / 2,
		-screen_size.y / 2 + initial_screen_size.y / 2
	)
	# North-East
	entrances[5].position = Vector2(
		screen_size.x / 2 - initial_screen_size.x / 2, screen_size.y / 2 - initial_screen_size.y / 2
	)
	# South-West
	entrances[6].position = Vector2(
		-screen_size.x / 2 + initial_screen_size.x / 2,
		-screen_size.y / 2 + initial_screen_size.y / 2
	)
	# South-East
	entrances[7].position = Vector2(
		screen_size.x / 2 - initial_screen_size.x / 2, screen_size.y / 2 - initial_screen_size.y / 2
	)
