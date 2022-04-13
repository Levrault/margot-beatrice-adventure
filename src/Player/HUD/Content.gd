extends Control

onready var tween := $Tween
onready var timer := $Timer


func _ready() -> void:
	Events.connect("player_hud_disabled", self, "_on_Hud_disabled")
	Events.connect("player_hud_enabled", self, "_on_Hud_enabled")
	timer.connect("timeout", self, "_on_Timeout")
	timer.start()


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


func _on_Timeout() -> void:
	hide()


func _on_Hud_disabled() -> void:
	.hide()


func _on_Hud_enabled() -> void:
	.show()
