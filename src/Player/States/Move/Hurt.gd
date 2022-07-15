# when owner is hurt, he's throwback on the opposite direction
# and will be granted with some invinsible frame
extends State

export var throwback_force := Vector2(500, 500)

onready var timer := $Timer
onready var sfx := $Impact


func physics_process(delta: float) -> void:
	var velocity = _parent.calculate_velocity(
		_parent.velocity,
		_parent.max_speed,
		_parent.acceleration,
		_parent.decceleration,
		delta,
		Vector2(owner.hit_direction, 1)
	)
	_parent.velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)

	Events.emit_signal("player_moved", owner)

	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle", {contact = true})


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("hurt")
	owner.hitbox.set_collision_mask_bit(Layer.DAMAGE_SOURCE_ENEMY_LAYER, false)
	owner.is_snapped_to_floor = false
	owner.is_handling_input = false
	owner.momentum.start()
	Game.stats.hits_taken += 1
	sfx.play_sound()
	if InputManager.is_using_gamepad():
		Input.start_joy_vibration(0, Config.values.gamepad_layout.gamepad_vibration, Config.values.gamepad_layout.gamepad_vibration, .3)

	if "impulse" in msg:
		throwback()


func exit() -> void:
	owner.hitbox.set_collision_mask_bit(Layer.DAMAGE_SOURCE_ENEMY_LAYER, true)
	owner.is_handling_input = true
	owner.is_snapped_to_floor = true
	owner.stats.set_invulnerable_for_seconds(1)
	_parent.velocity = Vector2.ZERO


func throwback() -> void:
	_parent.velocity.y = 0
	var impulse := Vector2(throwback_force.x * owner.hit_direction, throwback_force.y)
	_parent.velocity += calculate_throwback_velocity(impulse)


func calculate_throwback_velocity(impulse: Vector2) -> Vector2:
	return _parent.calculate_velocity(
		_parent.velocity, _parent.max_speed, impulse, Vector2.ZERO, 1.0, Vector2.UP
	)
