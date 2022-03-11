# Erase a profile
# @category: Button
extends GenericButton


func _on_Pressed() -> void:
	Events.emit_signal(
		"erase_profile_dialog_displayed", Serialize.PROFILE_SLOTS[owner.get_index()], self
	)
