# Keyboard key button template
# Use to write name with gamepad or keyboard
# @category: Button
extends GenericButton


func _on_Pressed() -> void:
	owner.form.profile_name += text
