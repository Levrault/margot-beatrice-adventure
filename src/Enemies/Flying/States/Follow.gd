extends State

const ARRIVE_DISTANCE := 25.0

export var max_speed := Vector2(50.0, 50.0)
export var acceleration := Vector2(10.0, 10.0)
export var decceleration := Vector2(10.0, 10.0)

var velocity := Vector2.ZERO
var path := []
var target_point_world: Vector2 = Vector2.ZERO

onready var _timer := $Timer


func physics_process(delta: float) -> void:
	if owner.target.global_position < owner.global_position:
		owner.flip(-1)
	elif owner.target.global_position > owner.global_position:
		owner.flip(1)
	var target_direction = (target_point_world - owner.global_position).normalized() * max_speed
	velocity = Move.calculate_velocity(
		velocity, max_speed, acceleration, decceleration, delta, target_direction, max_speed.y
	)
	velocity = owner.move_and_slide(velocity, Vector2.UP)
	if owner.global_position.distance_to(target_point_world) < ARRIVE_DISTANCE and len(path) > 0:
		path.remove(0)
		if len(path) == 0:
			return
		target_point_world = path[0]


func enter(msg: Dictionary = {}) -> void:
	assert(owner.target != null)

	# if the player exit the room
	Events.connect("room_transition_ended", _state_machine, "transition_to", ["Respawn"])

	_timer.connect("timeout", self, "_get_a_star_path")
	_timer.start()

	velocity = Vector2.ZERO

	_get_a_star_path()


func exit() -> void:
	_timer.stop()

	Events.disconnect("room_transition_ended", _state_machine, "transition_to")
	_timer.disconnect("timeout", self, "_get_a_star_path")
	velocity = Vector2.ZERO
	target_point_world = Vector2.ZERO
	print_debug("%s has stopped following the player" % owner.get_name())
	path = []


func _get_a_star_path() -> void:
	path = SceneManager.tilemap.find_path(owner.global_position, owner.target.position)
	if len(path) == 0:
		print_debug("%s a star failed on target position %s" % [owner.get_name(), String(owner.target.position)])
		return
	print_debug("%s is following player on %s" % [owner.get_name(), String(path[0])])
	target_point_world = path[0]
