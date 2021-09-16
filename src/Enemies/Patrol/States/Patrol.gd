extends State

export var max_speed_default := Vector2(75.0, 275.00)
export var acceleration_default := Vector2(10000, 800.0)
export var decceleration_default := Vector2(10000, 300.0)
export var max_speed_fall := 300.00
export var max_dash_count := 1

var acceleration := acceleration_default
var decceleration := decceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	if not $RayCastFloor.is_colliding() or $RayCastWall.is_colliding():
		owner.flip()
	velocity = Move.calculate_velocity(
		velocity, max_speed, acceleration, decceleration, delta, Vector2(owner.look_direction, 1.0)
	)
	velocity = owner.move_and_slide_with_snap(velocity, owner.SNAP, Vector2.UP, owner.stop_on_slope)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("patrol")


func exit() -> void:
	return
