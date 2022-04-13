extends Tween

enum Direction { UP, DOWN }

export var floating_value := 2.0
export var duration := 1.0
export var target_path := NodePath()
export var autostart := true

var direction = Direction.UP
var target = null


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("tween_all_completed", self, "_on_Tween_all_completed")

	target = get_node_or_null(target_path)
	if target == null:
		target = owner

	if autostart:
		toggle_floating()


func toggle_floating() -> void:
	if direction == Direction.DOWN:
		direction = Direction.UP
		interpolate_property(
			owner,
			"position",
			owner.position,
			Vector2(owner.position.x, owner.position.y - floating_value),
			duration
		)
		start()
		return

	direction = Direction.DOWN
	var new_position := Vector2(owner.position.x, owner.position.y + floating_value)
	interpolate_property(owner, "position", owner.position, new_position, duration)
	start()


func _on_Tween_all_completed() -> void:
	toggle_floating()
