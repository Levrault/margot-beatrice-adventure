# Erase a profile
# @category: Button
extends GenericButton


func _on_Pressed() -> void:
	Events.connect("menu_transition_mid_animated", self, "_on_Menu_transition_mid_animated")
	Events.emit_signal("menu_transition_started", "fade")


func _on_Menu_transition_mid_animated() -> void:
	Events.disconnect("menu_transition_mid_animated", self, "_on_Menu_transition_mid_animated")
	Serialize.erase(Serialize.PROFILE_SLOTS[owner.get_index()])
	owner.initialize_for_new_profile()
	owner.new_profile.call_deferred("grab_focus")
