extends Node2D

onready var camera := $CinematicCamera
onready var anim := $AnimationPlayer


func initialize() -> void:
	camera.current = true

	if Project.get_setting("sidepanel"):
		Events.call_deferred("emit_signal", "camera_changed", camera.get_name())

	anim.play("fade")
	Events.emit_signal("player_hud_disabled")
	Events.emit_signal("player_input_disabled")


func stop() -> void:
	anim.play("skip")


func emit_events_signal(signal_name: String) -> void:
	Events.emit_signal(signal_name)
	Events.emit_signal("player_hud_enabled")
	Events.emit_signal("dialogue_finished")
	Events.emit_signal("player_input_enabled")
