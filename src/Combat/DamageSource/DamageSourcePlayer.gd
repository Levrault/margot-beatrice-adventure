extends DamageSource


func _ready() -> void:
	connect("area_entered", self, "_on_Area_entered")


func _on_Area_entered(damage_source: Area2D) -> void:
	var direction = 1
	if damage_source.global_position.x > global_position.x:
		direction = -1
	owner.hit_direction = direction
	owner.state_machine.transition_to("Move/Air", {impulse = true})
	owner.momentum.start()
	Input.start_joy_vibration(0, Config.values.gamepad_layout.gamepad_vibration, Config.values.gamepad_layout.gamepad_vibration, .7)
