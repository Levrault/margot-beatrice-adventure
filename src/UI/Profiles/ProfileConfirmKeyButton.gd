# Enable to navigate between all the differents menu ui
# by setting up which menu needs to be show (based on node name)
# @category: Navigation
extends NavigationButton


# Only navigate to Worldmap, doesn't update
# history since the player shouldn't be able
# to go back to create profile back when clicking PreviousPage button
func _on_Pressed() -> void:
	owner.form.save()
	Menu.navigate_to(navigate_to)
	Events.emit_signal("new_profile_created", owner.form.profile)
	Game.current_profile = owner.form.profile
	owner.form.reset()
