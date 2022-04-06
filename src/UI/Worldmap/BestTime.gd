extends Label

onready var time_format := $TimeFormat


func _ready():
	Events.connect("worldmap_best_time_changed", self, "_on_Worldmap_best_time_changed")


func _on_Worldmap_best_time_changed(new_time: float) -> void:
	text = time_format.format_time(new_time)
