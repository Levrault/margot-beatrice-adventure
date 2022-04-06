extends GenericButton


func _on_Pressed() -> void:
	Events.emit_signal("loading_transition_started", "res://src/Levels/%s.tscn" % owner.next_level)
