extends Node2D

const BASE_LINE_WIDTH = 2.0
const DRAW_COLOR = Color('#fff')


func _ready() -> void:
	if not Project.get_setting("astart_highlight"):
		queue_free()
		return

	yield(get_parent(), "ready")
	set_as_toplevel(true)


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	var path = get_parent().path
	if not path:
		return

	var point_start = path[0]
	var point_to_map := Vector2(point_start.x, point_start.y)
	var last_point = point_to_map + SceneManager.tilemap.half_cell_size
	for index in range(1, len(path)):
		var current_point = (
			Vector2(path[index].x, path[index].y)
			+ SceneManager.tilemap.half_cell_size
		)
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = current_point
