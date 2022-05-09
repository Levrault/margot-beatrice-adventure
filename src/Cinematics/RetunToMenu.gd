extends Node2D


func start() -> void:
	Events.emit_signal("loading_transition_started", "res://src/UI/MainMenu.tscn")
''
