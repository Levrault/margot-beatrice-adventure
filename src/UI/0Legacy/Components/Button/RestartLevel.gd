extends Button


func _ready():
	connect("pressed", self, "_on_Pressed")


func _on_Pressed() -> void:
	AsyncLoading.goto_scene(SceneManager.path)
