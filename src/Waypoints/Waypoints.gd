tool
extends Line2D
class_name Waypoints

enum Mode { CYCLE, PING_PONG }

export (Mode) var mode := Mode.CYCLE setget set_mode
export var triangle_color := Color(1, 1, 1)
export var triangle_radius := 8.0

var _active_point_index := 0
var _direction := 1


func _ready() -> void:
	set_as_toplevel(true)

	if not Engine.editor_hint:
		self_modulate = Color(1, 1, 1, 0)

	if (not get_child(0) is Platform and not get_child(0) is Enemy) or get_child_count() == 0:
		printerr("Missing Platform or Enemy node for %s: %s" % [name, get_path()])

	# set chain texture to link waypoints
	if not points.size() > 1:
		return

	if Engine.editor_hint:
		return


func _draw() -> void:
	if not Engine.editor_hint:
		return
	if not points.size() > 1:
		return
	var triangles := []
	var previous_point := points[0]
	for point in points:
		if point == points[0] or (point == points[-1] and mode == Mode.CYCLE):
			continue
		triangles.append(
			{center = (point + previous_point) / 2, angle = previous_point.angle_to_point(point)}
		)
		previous_point = point
	if mode == Mode.CYCLE:
		triangles.append(
			{center = (points[-1] - points[0]) / 2, angle = points[-1].angle_to_point(points[0])}
		)
		draw_line(points[-1], points[0], default_color, width)
	for triangle in triangles:
		DrawingUtils.draw_triangle(
			self, triangle.center, triangle.angle, triangle_radius, triangle_color
		)


func get_start_position() -> Vector2:
	return points[0]


func reset() -> void:
	_active_point_index = 0


func get_current_point_position() -> Vector2:
	return points[_active_point_index]


func get_next_point_position():
	match mode:
		Mode.CYCLE:
			_active_point_index = (_active_point_index + 1) % points.size()
		Mode.PING_PONG:
			var index := _active_point_index + _direction
			if index < 0 or index > points.size() - 1:
				_direction *= -1
			_active_point_index += _direction
	return get_current_point_position()


func set_mode(value: int) -> void:
	mode = value
	update()
