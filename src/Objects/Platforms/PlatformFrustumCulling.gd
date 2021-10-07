extends FrustumCulling


func _on_Room_transition_started() -> void:
	._on_Room_transition_started()

	if owner.waypoints.has_method("reset"):
		owner.waypoints.reset()
		owner.timer.start()


func _on_Room_limit_changed(bounds: Dictionary) -> void:
	._on_Room_limit_changed(bounds)

	if not is_screen_visible:
		owner.tween.stop_all()
		owner.tween.remove_all()
		owner.timer.stop()
