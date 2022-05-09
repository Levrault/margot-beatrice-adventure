extends GenericButton


func _on_Pressed() -> void:
	Events.emit_signal("loading_transition_started", owner.scene_path + "%s.tscn" % owner.next_level)
