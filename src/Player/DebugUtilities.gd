extends Node2D


func _ready() -> void:
	if not ProjectSettings.get_setting("game/debug"):
		queue_free()
