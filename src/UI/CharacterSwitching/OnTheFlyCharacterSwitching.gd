extends Control

var current_control: Control = null

onready var gamepad := $Gamepad
onready var keyboard := $Keyboard
onready var tween := $Tween
onready var timer := $Timer


func _ready():
	Events.connect("player_hud_disabled", self, "hide")
	Events.connect("player_hud_enabled", self, "show")
	Events.connect("player_character_changed", self, "_on_Player_character_changed")
	InputManager.connect("device_changed", self, "_on_Device_changed")
	timer.connect("timeout", self, "_on_Timeout")

	_on_Device_changed(InputManager.device, 0)
	_on_Player_character_changed()


func hide() -> void:
	tween.interpolate_property(
		self, "modulate:a", self.modulate.a, 0.0, .250, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	tween.start()


func show() -> void:
	tween.interpolate_property(
		self, "modulate:a", self.modulate.a, 1.0, .250, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	tween.start()
	timer.stop()
	timer.start()


func _on_Device_changed(device: String, device_index: int) -> void:
	if InputManager.is_using_gamepad():
		gamepad.show()
		keyboard.hide()
		current_control = gamepad
		return
	gamepad.hide()
	keyboard.show()
	current_control = keyboard


func _on_Player_character_changed() -> void:
	if Character.selected == Character.Playable.FOX:
		current_control.get_node("Fox").modulate.a = 1.0
		current_control.get_node("Rabbit").modulate.a = .5
		current_control.get_node("Squirrel").modulate.a = .5
	elif Character.selected == Character.Playable.RABBIT:
		current_control.get_node("Fox").modulate.a = .5
		current_control.get_node("Rabbit").modulate.a = 1.0
		current_control.get_node("Squirrel").modulate.a = .5
	else:
		current_control.get_node("Fox").modulate.a = .5
		current_control.get_node("Rabbit").modulate.a = .5
		current_control.get_node("Squirrel").modulate.a = 1.0

	show()


func _on_Timeout() -> void:
	hide()
