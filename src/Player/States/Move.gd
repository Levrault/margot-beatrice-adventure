extends State
class_name Move

export var max_speed_default := Vector2(200.0, 675.00)
export var acceleration_default := Vector2(10000, 1800.0)
export var decceleration_default := Vector2(10000, 3000.0)
export var max_speed_fall := 900.00
export var max_dash_count := 1

var acceleration := acceleration_default
var decceleration := decceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO
var dash_count := 0

var _is_move_down_key_pressed := false

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 1.0
	)

static func calculate_velocity(
	old_velocity: Vector2,
	max_speed: Vector2,
	acceleration: Vector2,
	decceleration: Vector2,
	delta: float,
	move_direction: Vector2,
	max_speed_fall := 1500.00
) -> Vector2:
	var new_velocity := old_velocity
	new_velocity.y += move_direction.y * acceleration.y * delta

	if move_direction.x:
		new_velocity.x += move_direction.x * acceleration.x * delta
	elif abs(new_velocity.x) > 0.1:
		new_velocity.x -= decceleration.x * delta * sign(new_velocity.x)
		new_velocity.x = new_velocity.x if sign(new_velocity.x) == sign(old_velocity.x) else 0.0

	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed_fall)

	return new_velocity


func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor():
		if not _is_move_down_key_pressed and event.is_action_pressed("jump"):
			_state_machine.transition_to("Move/Air", {impulse = true})
			return
		if _is_move_down_key_pressed and event.is_action_pressed("jump"):
			owner.is_on_moving_platform = false
			owner.set_collision_mask_bit(Layer.PASS_TROUGHT_LAYER, false)
			_state_machine.transition_to("Move/Air")
			return

	if event.is_action_pressed("move_down"):
		_is_move_down_key_pressed = true
		return
	if event.is_action_released("move_down"):
		_is_move_down_key_pressed = false
		return

	if event.is_action_pressed("dash") and dash_count < max_dash_count:
		dash_count += 1
		_state_machine.transition_to("Move/Dash")


func physics_process(delta: float) -> void:
	var direction := get_move_direction()

	if not owner.is_handling_input:
		direction.x = 0

	owner.flip(direction.x)

	velocity = calculate_velocity(
		velocity, max_speed, acceleration, decceleration, delta, direction
	)

	if owner.is_snapped_to_floor:
		if owner.is_on_moving_platform and (_state_machine.state_name != "Air" and velocity.y > 0):
			velocity.y = 0

		velocity = owner.move_and_slide_with_snap(
			velocity, owner.SNAP, owner.FLOOR_NORMAL, owner.stop_on_slope
		)
	else:
		velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)

	Events.emit_signal("player_moved", owner)


func enter(msg: Dictionary = {}) -> void:
	$Air.connect("jumped", $Idle.jump_input_buffering, "start")
	owner.pass_through.connect("body_exited", self, "_on_PassThrough_exited")


func exit() -> void:
	$Air.disconnect("jumped", $Idle.jump_input_buffering, "start")
	owner.pass_through.disconnect("body_exited", self, "_on_PassThrough_exited")


func _on_PassThrough_exited(body) -> void:
	owner.set_collision_mask_bit(Layer.PASS_TROUGHT_LAYER, true)
