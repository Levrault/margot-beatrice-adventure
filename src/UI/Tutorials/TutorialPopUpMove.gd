extends TutorialPopUp

onready var joystick_action := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/JoystickAtlasIcon
onready var altas_move_left := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AtlasIcon
onready var altas_move_up := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AtlasIconMoveUp
onready var altas_move_right := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AtlasIconMoveRight
onready var altas_move_down := $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AtlasIconMoveDown


func _ready() -> void:
	InputManager.connect("device_changed", self, "_on_Device_changed")
	if InputManager.is_using_gamepad():
		altas_move_up.hide()
		altas_move_right.hide()
		altas_move_down.hide()


func _on_Device_changed(device: String, device_index: int) -> void:
	if InputManager.is_using_gamepad():
		joystick_action.show()
		altas_move_left.hide()
		altas_move_up.hide()
		altas_move_right.hide()
		altas_move_down.hide()
		return

	joystick_action.hide()
	altas_move_left.show()
	altas_move_up.show()
	altas_move_right.show()
	altas_move_down.show()
