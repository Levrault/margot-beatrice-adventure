extends Label

const COMPLETED_PERCENTAGE_COLOR := Color("#fbf236")
export var signal_to_connect := ""


func _ready():
	Events.connect(signal_to_connect, self, "_on_Worldmap_percentage_changed")


func _on_Worldmap_percentage_changed(value: int, max_value: int) -> void:
	# warning-ignore:integer_division
	var percentage = value * 100 / max_value if value > 0 else 0
	var rounded_percentage = int(round(percentage))
	text = String(rounded_percentage) + "%"
	if rounded_percentage == 100:
		modulate = COMPLETED_PERCENTAGE_COLOR
