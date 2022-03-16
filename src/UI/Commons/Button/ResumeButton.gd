extends GenericButton


func _on_Pressed() -> void:
	Events.emit_signal("in_game_menu_hidden")
