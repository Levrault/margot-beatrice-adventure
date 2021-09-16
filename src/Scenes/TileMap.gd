# source https://github.com/GDQuest/godot-demos/blob/master/2018/03-30-astar-pathfinding/pathfind_astar.gd
extends TileMap

const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')

export var map_size := Vector2(16, 16)

var path_start_position = Vector2() setget _set_path_start_position
var path_end_position = Vector2() setget _set_path_end_position

var _point_path = []
var _tile_range_reference := Vector2.ZERO

onready var astar_node = AStar2D.new()
onready var obstacles = get_used_cells()
onready var _half_cell_size = cell_size / 2


func _ready():
	if not has_node("EndOfLevel"):
		printerr("EndOfLevel node is missing for %s : %s" % [name, get_path()])

	Events.connect("room_transition_ended", self, "_on_Room_transition_ended")
	SceneManager.tilemap = self


#	astar_connect_walkable_cells_diagonal(astar_add_walkable_cells(obstacles))


# Loops through all cells within the map's bounds and
# adds all points to the astar_node, except the obstacles
func astar_add_walkable_cells(obstacles = []):
	var points_array = []
	for y in range(_tile_range_reference.y, _tile_range_reference.y + map_size.y):
		for x in range(_tile_range_reference.x, _tile_range_reference.x + map_size.x):
			var point = Vector2(x, y)
			if point in obstacles:
				continue

			points_array.append(point)
			var point_index = calculate_point_index(point)
			astar_node.add_point(point_index, Vector2(point.x, point.y))
	return points_array


# Once you added all points to the AStar node, you've got to connect them
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like
func astar_connect_walkable_cells(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstacle,
		# We connect the current point with it
		var points_relative = PoolVector2Array(
			[
				Vector2(point.x + 1, point.y),
				Vector2(point.x - 1, point.y),
				Vector2(point.x, point.y + 1),
				Vector2(point.x, point.y - 1)
			]
		)
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)

			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			# Note the 3rd argument. It tells the astar_node that we want the
			# connection to be bilateral: from point A to B and B to A
			# If you set this value to false, it becomes a one-way path
			# As we loop through all points we can set it to false
			astar_node.connect_points(point_index, point_relative_index, false)


# This is a variation of the method above
# It connects cells horizontally, vertically AND diagonally
func astar_connect_walkable_cells_diagonal(points_array):
	for point in points_array:
		var point_index = calculate_point_index(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = calculate_point_index(point_relative)

				if point_relative == point or is_outside_map_bounds(point_relative):
					continue
				if not astar_node.has_point(point_relative_index):
					continue
				astar_node.connect_points(point_index, point_relative_index, true)


func is_outside_map_bounds(point):
	return (
		point.x < _tile_range_reference.x
		or point.y < _tile_range_reference.y
		or point.x >= (_tile_range_reference.x + map_size.x)
		or point.y >= (_tile_range_reference.y + map_size.y)
	)


func calculate_point_index(point):
	return point.x + (_tile_range_reference.x + map_size.x) * abs(point.y)


func find_path(world_start, world_end):
	self.path_start_position = world_to_map(world_start)
	self.path_end_position = world_to_map(world_end)
	_recalculate_path()
	var path_world = []
	for point in _point_path:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _half_cell_size
		path_world.append(point_world)
	return path_world


func _recalculate_path():
	var start_point_index = calculate_point_index(path_start_position)
	var end_point_index = calculate_point_index(path_end_position)
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	update()


func _draw():
	if not _point_path:
		return

	var point_start = _point_path[0]
	var last_point = map_to_world(Vector2(point_start.x, point_start.y)) + _half_cell_size
	for index in range(1, len(_point_path)):
		var current_point = (
			map_to_world(Vector2(_point_path[index].x, _point_path[index].y))
			+ _half_cell_size
		)
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = current_point


func _on_Room_transition_ended() -> void:
	_tile_range_reference = world_to_map(to_local(SceneManager.anchor.boundsNW.global_position))
	astar_connect_walkable_cells_diagonal(astar_add_walkable_cells(obstacles))


# Setters for the start and end path values.
func _set_path_start_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	path_start_position = value
	if path_end_position and path_end_position != path_start_position:
		_recalculate_path()


func _set_path_end_position(value):
	if value in obstacles:
		return
	if is_outside_map_bounds(value):
		return

	path_end_position = value
	if path_start_position != value:
		_recalculate_path()
