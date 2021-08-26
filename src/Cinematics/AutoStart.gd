extends Node2D


func _ready():
	Events.emit_signal("cinematic_started")
