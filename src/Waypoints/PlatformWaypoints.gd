tool
extends Waypoints

var chain_small_scene := preload("res://src/Objects/Platforms/ChainSmall.tscn")
var chain_big_scene := preload("res://src/Objects/Platforms/ChainBig.tscn")


func _ready() -> void:
	._ready()
	if get_child(0) is Platform:
		_init_chains_path()


func _init_chains_path() -> void:
	var previous_point := points[0]
	for point in points:
		# add visual points for each "stop"

		var new_chain_big = chain_big_scene.instance()
		add_child(new_chain_big)
		new_chain_big.position = point

		if point == points[0]:
			continue

		_chain_factory(
			{
				position = (point + previous_point) / 2,
				height = round(previous_point.distance_to(point)),
				angle = round(rad2deg(previous_point.angle_to_point(point)))
			}
		)
		previous_point = point

	if mode == Mode.CYCLE:
		_chain_factory(
			{
				position = (points[-1] + points[0]) / 2,
				height = round(points[-1].distance_to(points[0])),
				angle = round(rad2deg(points[-1].angle_to_point(points[0])))
			}
		)


func _chain_factory(data: Dictionary) -> void:
	var new_chain_small = chain_small_scene.instance()
	add_child(new_chain_small)
	new_chain_small.position = data.position
	new_chain_small.region_rect = Rect2(0, 0, data.height - 8, 8)
	new_chain_small.rotation_degrees = data.angle
