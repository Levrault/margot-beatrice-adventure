extends GenericButton


func _on_Pressed() -> void:
	Events.emit_signal("loading_transtion_started", "res://src/UI/MainMenu.tscn")
