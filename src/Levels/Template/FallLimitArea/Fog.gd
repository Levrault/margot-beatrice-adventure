extends Sprite

enum { FORWARD, BACKWARD }

const VALUE := 3.0
const DURATION := 2.0

var index = FORWARD
var from = 0
var to = 0

onready var tween := $Tween


func _ready() -> void:
	tween.connect("tween_completed", self, "_on_Tween_completed")
	from = position
	to = Vector2(position.x + VALUE, position.y)

	tween.interpolate_property(self, "position", from, to, 2, Tween.EASE_IN, Tween.EASE_OUT)

	tween.start()


func _on_Tween_completed(object: Object, key: NodePath) -> void:
	index += 1
	if index > BACKWARD:
		index = FORWARD

	match index:
		FORWARD:
			tween.interpolate_property(
				self, "position", from, to, DURATION, Tween.EASE_IN, Tween.EASE_OUT
			)
		BACKWARD:
			tween.interpolate_property(
				self, "position", to, from, DURATION, Tween.EASE_IN, Tween.EASE_OUT
			)

	tween.start()
