# If the room fit the screen size
#	Root position 2d is used to made the transition
# If the room is bigger,
#	both east and west entrance are placed to be used in the transition
extends Position2D
class_name CameraAnchor

export var screen_size: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)
var initial_screen_size := Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)

onready var boundsNW := $BoundsNW
onready var boundsSE := $BoundsSE


func _ready() -> void:
	boundsNW.position = Vector2(-screen_size.x / 2, -screen_size.y / 2)
	boundsSE.position = Vector2(screen_size.x / 2, screen_size.y / 2)


func get_bounds() -> Dictionary:
	return {
		'limit_left': boundsNW.global_position.x,
		'limit_top': boundsNW.global_position.y,
		'limit_right': boundsSE.global_position.x,
		'limit_bottom': boundsSE.global_position.y,
	}


func update_anchor_limit() -> void:
	SceneManager.bounds = get_bounds()
	Events.emit_signal("room_limit_changed", SceneManager.bounds)
	Events.emit_signal("room_transition_ended")
	get_tree().paused = false
