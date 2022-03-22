extends State


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.max_speed.x = _parent.max_speed_default.x
	if owner.is_on_floor():
		if _parent.velocity.length() < 1.0 and not owner.is_on_wall():
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air", {coyote_time = true})
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	owner.skin.play("run")


func exit() -> void:
	_parent.exit()
