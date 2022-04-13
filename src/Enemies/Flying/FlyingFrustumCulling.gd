extends EnemyFrustumCulling


func _on_Room_transition_started() -> void:
	# fix position issue if wasp is in follow mode
	if owner.state_machine.state_name != "Follow":
		owner.set_deferred("position", initial_position)

	owner.skin.anim.stop()


func _on_Room_limit_changed(bounds: Dictionary) -> void:
	._on_Room_limit_changed(bounds)
	owner.player_detector.disabled = not is_screen_visible

	if owner.state_machine.state_name == "Follow":
		owner.set_deferred("position", initial_position)
