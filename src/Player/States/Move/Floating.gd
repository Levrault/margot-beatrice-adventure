extends State

export var max_speed_default := Vector2(200.0, -240.00)
export var acceleration_default := Vector2(10000, -350.0)
export var decceleration_default := Vector2(10000, -350.0)

var acceleration := acceleration_default
var decceleration := decceleration_default
var max_speed := max_speed_default
var velocity := Vector2(0, -100)

# Allow the player to float
# max_speed is positive instead of negative (see Move.gd)
static func calculate_velocity(
	old_velocity: Vector2,
	max_speed: Vector2,
	acceleration: Vector2,
	decceleration: Vector2,
	delta: float,
	move_direction: Vector2,
	max_speed_fall := 200.00
) -> Vector2:
	var new_velocity := old_velocity
	new_velocity.y += move_direction.y * acceleration.y * delta

	if move_direction.x:
		new_velocity.x += move_direction.x * acceleration.x * delta
	elif abs(new_velocity.x) > 0.1:
		new_velocity.x -= decceleration.x * delta * sign(new_velocity.x)
		new_velocity.x = new_velocity.x if sign(new_velocity.x) == sign(old_velocity.x) else 0.0

	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, max_speed.y, max_speed_fall)

	return new_velocity


func physics_process(delta: float) -> void:
	velocity = calculate_velocity(
		velocity, max_speed, acceleration, decceleration, delta, _parent.get_move_direction()
	)
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("fall")
	owner.is_snapped_to_floor = false


func exit() -> void:
	velocity = Vector2(0, -100)
