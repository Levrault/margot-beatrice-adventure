extends Label


func _ready():
	Events.connect("worldmap_best_time_changed", self, "_on_Worldmap_best_time_changed")


func _on_Worldmap_best_time_changed(new_time: float) -> void:
	text = String(new_time)
