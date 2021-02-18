extends Button


func _ready():
	connect("pressed", self, "_on_Pressed")


func _on_Pressed() -> void:
	Menu.navigate_to(Menu.history.pop_back())
