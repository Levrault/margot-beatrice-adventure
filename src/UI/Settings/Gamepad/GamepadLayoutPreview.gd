# Show the current gamepad layout
# Depend on current gamepad biding
# and if left and right stick are inverted
# @category: Gamepad, Field, Rebind
extends Control

var gamepad_data_buttons_list := []
var gamepad_data_sticks_list := []
var actions := {}


func _ready():
	yield(owner, "ready")
	Events.connect("gamepad_layout_changed", self, "_on_Gamepad_layout_changed")
	Events.connect("gamepad_stick_layout_changed", self, "_on_Gamepad_stick_layout_changed")

	var stick_left := $Panel/StickLeft
	var stick_right := $Panel/StickRight

	for child in $Panel.get_children():
		if child is GamepadData:
			if child == stick_left or child == stick_right:
				gamepad_data_sticks_list.append(child)
				continue
			gamepad_data_buttons_list.append(child)

	# get all available actions
	for action in EngineSettings.gamepad[InputManager.DEVICE_XBOX_CONTROLLER].default:
		actions[action] = {}

	_on_Gamepad_layout_changed()


func _on_Gamepad_layout_changed() -> void:
	# clear current layout
	for data in gamepad_data_buttons_list:
		data.action = ""

	var layout = Config.values[owner.form.engine_file_section].gamepad_layout
	var device = (
		InputManager.device
		if InputManager.is_using_gamepad()
		else InputManager.DEVICE_XBOX_CONTROLLER
	)

	if layout == "custom":
		for key in Config.values.gamepad_bindind[device]:
			actions[key] = Config.values.gamepad_bindind[device][key].default
	else:
		for key in EngineSettings.gamepad[device][layout]:
			actions[key] = EngineSettings.gamepad[device][layout][key].default

	for key in actions:
		for data in gamepad_data_buttons_list:
			print(data)
			if data.joy_values.find(actions[key]) == -1:
				continue
			data.action = key


func _on_Gamepad_stick_layout_changed(joy_actions: Array) -> void:
		# clear current layout
	for data in gamepad_data_sticks_list:
		data.action = ""

	for action in joy_actions:
		for data in gamepad_data_sticks_list:
			if data.joy_values.find(action) != -1:
				data.action = action
				return