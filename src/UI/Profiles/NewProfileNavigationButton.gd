# Enable to navigate between all the differents menu ui
# by setting up which menu needs to be show (based on node name)
# @category: Navigation
extends NavigationButton


# Update Menu navigation history (Autoload/Menu.gd)
# Set itself at last clicked button
func _on_Pressed() -> void:
	._on_Pressed()
	Events.emit_signal("new_profile_page_displayed", Serialize.PROFILE_SLOTS[owner.get_index()])
