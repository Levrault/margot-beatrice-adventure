extends Control

var current_device := InputManager.device
onready var anim := $AnimationPlayer
onready var label := $PanelContainer/MarginContainer/Label


func _ready():
	InputManager.connect("device_changed", self, "_on_Device_changed")
	current_device = InputManager.device


func _on_Device_changed(device: String, device_index: int) -> void:
	if device == InputManager.DEVICE_MOUSE:
		device = InputManager.DEVICE_KEYBOARD

	if device == current_device:
		return

	label.text = tr("commons.device_changed").format({device = device})
	anim.play("show")
	current_device = device
