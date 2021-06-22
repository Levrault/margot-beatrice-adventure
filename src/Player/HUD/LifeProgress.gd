tool
extends TextureProgress

export (Color) var COLOR: Color setget set_color_normal


func _ready() -> void:
	$TweenColor.connect("tween_completed", self, "_on_tween_color_completed")


# @param {Color} value
func set_color_normal(value: Color) -> void:
	COLOR = value
	modulate = value


# Animated ui change
# @param {float} new_value
func _on_Health_changed(new_value: float, old_value: float) -> void:
	owner.content.show()
	$TweenColor.interpolate_property(
		self, "modulate", modulate, Color(255, 255, 255), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN
	)
	$TweenColor.start()

	$TweenProgress.interpolate_property(
		self, "value", old_value, new_value, 0.3, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	)
	$TweenProgress.start()


# @signal tween_completed
# @param {Object} object
# @param {NodePath} key
func _on_tween_color_completed(object: Object, key: NodePath) -> void:
	set_color_normal(COLOR)
