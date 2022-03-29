extends ParallaxBackground


func _ready() -> void:
	yield(owner, "ready")
	Events.connect("room_transition_started", self, "_on_Room_transition_started")


func _on_Room_transition_started() -> void:
	scroll_offset = SceneManager.anchor.position
