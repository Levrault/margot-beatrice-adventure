extends GenericButton


func _ready() -> void:
	if owner.next_level.empty():
		printerr("%s - Next level isn`t set" % owner.get_name())


func _on_Pressed() -> void:
	Events.emit_signal("loading_transition_started", "res://src/UI/MainMenu.tscn")
