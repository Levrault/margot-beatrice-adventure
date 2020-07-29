extends TextureRect


func _ready() -> void:
	Events.connect("player_character_changed", self, "_on_Character_changed")


func _on_Character_changed() -> void:
	for child in get_children():
		if child.get_name() != Character.get_selected_character_name():
			child.hide()
			continue
		child.show()
