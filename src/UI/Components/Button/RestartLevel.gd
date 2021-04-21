extends Button


func _ready():
	connect("pressed", self, "_on_Pressed")


func _on_Pressed() -> void:
	get_tree().reload_current_scene()
