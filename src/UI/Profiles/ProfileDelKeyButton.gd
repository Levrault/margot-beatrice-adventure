# Keyboard key button template
# Use to write name with gamepad or keyboard
# @category: Button
extends GenericButton


func _on_Pressed() -> void:
	owner.form.profile_name = owner.form.profile_name.left(owner.form.profile_name.length() - 1)
