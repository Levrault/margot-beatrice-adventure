# Detect witch device is currently
# Provide some usefull function about gamepad or keyboard action
# Contains all key icons of all device
# @see https://github.com/nathanhoad/godot_input_helper/blob/main/input_helper/input_helper.gd
extends Node

signal device_changed(device, device_index)

const DEVICE_KEYBOARD := "keyboard"
const DEVICE_MOUSE := "mouse"
const DEVICE_XBOX_CONTROLLER := "xbox"
const DEVICE_SWITCH_CONTROLLER := "nintendo"
const DEVICE_PLAYSTATION_CONTROLLER := "dualshock"
const DEVICE_GENERIC := "generic"
const GAMEPAD_MOTION_REGEX := "_AXIS_|_ANALOG_"

var dualshock_circle = preload("res://assets/ui/dualshock_CIRCLE.png")
var dualshock_triangle = preload("res://assets/ui/dualshock_TRIANGLE.png")
var xbox_b = preload("res://assets/ui/xbox_B.png")
var xbox_y = preload("res://assets/ui/xbox_Y.png")
var nintendo_a = preload("res://assets/ui/nintendo_A.png")
var nintendo_x = preload("res://assets/ui/nintendo_X.png")
var keyboard_esc = preload("res://assets/ui/keyboard_ESC.png")
var keyboard_del = preload("res://assets/ui/keyboard_DEL.png")
var keyboard_f = preload("res://assets/ui/keyboard_F.png")
var all_gamepad_devices := [
	DEVICE_XBOX_CONTROLLER,
	DEVICE_SWITCH_CONTROLLER,
	DEVICE_PLAYSTATION_CONTROLLER,
	DEVICE_GENERIC
]
var device: String = DEVICE_XBOX_CONTROLLER setget _set_device
var device_index: int = -1
var default_gamepad: String = DEVICE_XBOX_CONTROLLER
var gamepad_button_regex := {"xbox": "_XBOX_", "nintendo": "_DS_", "dualshock": "_SONY_", "generic": "_BUTTON_"}

var _motion_regex := RegEx.new()


func _ready() -> void:
	_motion_regex.compile(GAMEPAD_MOTION_REGEX)


# Based on the current input, will update wich device is used
func _input(event: InputEvent) -> void:
	var next_device: String = device
	var next_device_index: int = device_index

	# keyboard
	if event is InputEventKey and event.is_pressed():
		next_device = DEVICE_KEYBOARD
		next_device_index = -1

	# mouse
	if (event is InputEventMouseButton and event.is_pressed()) or event is InputEventMouseMotion:
		next_device = DEVICE_MOUSE
		next_device_index = -1

	# gamepad
	if (
		(event is InputEventJoypadButton and event.is_pressed())
		or (event is InputEventJoypadMotion and event.axis_value > 0.1)
	):
		next_device = get_simplified_device_name(Input.get_joy_name(event.device))
		next_device_index = event.device

	if next_device != device or next_device_index != device_index:
		self.device = next_device
		device_index = next_device_index
		emit_signal("device_changed", device, device_index)


# Utils function to quickly add a motion event
func addJoyMotionEvent(action: String, value: String) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var input_event_motion = InputEventJoypadMotion.new()
	input_event_motion.axis = EngineSettings.keylist.gamepad[value]
	InputMap.action_add_event(action, input_event_motion)


# Utils function to quickly remove a motion event
func removeJoyMotionEvent(action: String, value: String) -> void:
	if not InputMap.has_action(action):
		return
	var input_event_motion = InputEventJoypadMotion.new()
	input_event_motion.axis = EngineSettings.keylist.gamepad[value]
	InputMap.action_erase_event(action, input_event_motion)


# Utils function to add a joy button event
func addJoyButtonEvent(action: String, value: String) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var input_event_button = InputEventJoypadButton.new()
	input_event_button.button_index = EngineSettings.keylist.gamepad[value]
	InputMap.action_add_event(action, input_event_button)


# Utils function to remove a joy button event
func removeJoyButtonEvent(action: String, value: String) -> void:
	if not InputMap.has_action(action):
		return
	var input_event_button = InputEventJoypadButton.new()
	input_event_button.button_index = EngineSettings.keylist.gamepad[value]
	InputMap.action_erase_event(action, input_event_button)


# return a understable device name
func get_simplified_device_name(raw_name: String) -> String:
	match raw_name:
		"XInput Gamepad", "Xbox Series Controller":
			return DEVICE_XBOX_CONTROLLER
		"PS5 Controller", "PS4 Controller", "PS3 Controller", "PS2 Controller":
			return DEVICE_PLAYSTATION_CONTROLLER
		"Switch":
			return DEVICE_SWITCH_CONTROLLER
		_:
			return DEVICE_GENERIC


func is_using_gamepad() -> bool:
	var result := false
	for gamepad_device in all_gamepad_devices:
		if device == gamepad_device:
			result = true
	return result


func is_motion_event(value: String) -> bool:
	return _motion_regex.search(value) != null


# return the global scope variable name from a action/device
func get_device_button_from_action(action: String, for_device: String) -> String:
	if not InputMap.has_action(action):
		printerr("Action %s does not exist" % action)
		return ""
	var result := ""
	for evt in InputMap.get_action_list(action):
		if for_device == DEVICE_KEYBOARD or for_device == DEVICE_MOUSE:
			if evt is InputEventKey:
				return OS.get_scancode_string(evt.scancode)
		else:
			if evt is InputEventJoypadButton:
				return EngineSettings.get_gamepad_button_from_joy_string(
					evt.button_index, Input.get_joy_button_string(evt.button_index), for_device
				)
	printerr("Not key were for found for %s on device %s" % [action, for_device])
	return result


func get_device_button_texture_from_action(action: String, for_device: String) -> Texture:
	if not InputMap.has_action(action):
		printerr("Action %s does not exist" % action)
		return null

	var result := ""
	for evt in InputMap.get_action_list(action):
		if for_device == DEVICE_KEYBOARD or for_device == DEVICE_MOUSE:
			if evt is InputEventKey:
				result = OS.get_scancode_string(evt.scancode)
		else:
			if evt is InputEventJoypadButton:
				result = EngineSettings.get_gamepad_button_from_joy_string(
					evt.button_index, Input.get_joy_button_string(evt.button_index), for_device
				)
	if result.empty():
		printerr("Not key were for found for %s on device %s" % [action, for_device])

	match result:
		"JOY_SONY_CIRCLE":
			return dualshock_circle
		"JOY_DS_A":
			return nintendo_a
		"JOY_XBOX_B":
			return xbox_b
		"JOY_SONY_TRIANGLE":
			return dualshock_triangle
		"JOY_DS_X":
			return nintendo_x
		"JOY_XBOX_Y":
			return xbox_y
		"Escape":
			return keyboard_esc
		"Delete":
			return keyboard_del
		"F":
			return keyboard_f
	return null


func _set_device(value: String) -> void:
	device = value

	if device == DEVICE_KEYBOARD or device == DEVICE_MOUSE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
