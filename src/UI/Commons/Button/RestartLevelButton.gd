extends GenericButton


func _on_Pressed() -> void:
	print_debug("Restart level - load res://src/Levels/%s" % Game.current_level)
	Events.emit_signal(
		"loading_transition_started", "res://src/Levels/%s.tscn" % Game.current_level
	)
