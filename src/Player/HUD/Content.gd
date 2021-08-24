extends Control


func _ready() -> void:
	$Timer.connect("timeout", self, "_on_Timeout")
	$Timer.start()


func hide() -> void:
	$Tween.interpolate_property(
		self, "modulate:a", self.modulate.a, 0.0, .250, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	$Tween.start()


func show() -> void:
	$Tween.interpolate_property(
		self, "modulate:a", self.modulate.a, 1.0, .250, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	$Tween.start()
	$Timer.stop()
	$Timer.start()


func _on_Timeout() -> void:
	hide()
