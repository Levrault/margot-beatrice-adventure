# Enable to navigate between all the differents menu ui
# by setting up wich menu need to be show (based on node name)
class_name NavigationButton
extends AnimatedButton

export var navigate_to := ""
export var clear_history := false
export var is_default_focused := false


# Focus itself if default focused and menu is visible
func _ready() -> void:
	connect("pressed", self, "_on_Pressed")

	yield(owner, "ready")

	if is_default_focused:
		owner.last_clicked_button = self

		if owner.visible:
			grab_focus()


# Update Menu navigation history (Autoload/Menu.gd)
# Set itself at last clicked button
# Show navigate_to
func _on_Pressed() -> void:
	owner.last_clicked_button = self
	Menu.history.append(owner.get_name())
	Menu.navigate_to(navigate_to)
	if clear_history:
		Menu.history.clear()
	print_debug("%s has change navigation history : %s" % [owner.get_name(), Menu.history])
