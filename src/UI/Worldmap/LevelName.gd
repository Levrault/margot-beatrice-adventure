extends Label


func _ready():
	Events.connect("worldmap_level_name_changed", self, "_on_Worldmap_level_name_changed")


func _on_Worldmap_level_name_changed(new_text: String) -> void:
	text = tr(new_text)
