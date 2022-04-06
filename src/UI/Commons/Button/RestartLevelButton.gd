extends GenericButton


func _ready() -> void:
	if owner.next_level.empty():
		printerr("%s - Next level isn`t set" % owner.get_name())


func _on_Pressed() -> void:
	print_debug("Restart level - load res://src/Levels/%s" % owner.owner.get_name())
	Events.emit_signal("loading_transition_started", "res://src/Levels/%s.tscn" % owner.owner.get_name())
