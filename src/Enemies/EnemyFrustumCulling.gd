extends FrustumCulling
class_name EnemyFrustumCulling

var initial_look_direction := 1


func _ready() -> void:
	initial_look_direction = owner.look_direction


func _on_Room_transition_started() -> void:
	._on_Room_transition_started()
	owner.skin.anim.stop()


func _on_Room_transition_ended() -> void:
	owner.state_machine.call_deferred("reset")
	owner.call_deferred("flip", initial_look_direction)
	if not is_screen_visible:
		owner.skin.anim.call_deferred("stop")


func _on_Room_limit_changed(bounds: Dictionary) -> void:
	._on_Room_limit_changed(bounds)
	owner.state_machine.call_deferred("set_physics_process", is_screen_visible)
	owner.state_machine.call_deferred("set_process", is_screen_visible)
