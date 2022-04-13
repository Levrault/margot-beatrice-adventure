extends Control

var time := 0.0

onready var time_format := $TimeFormat


func _ready() -> void:
	Events.connect("player_hud_disabled", self, "hide")
	Events.connect("player_hud_enabled", self, "show")
	Events.connect("level_started", self, "_on_Level_started")
	Events.connect("level_finished", self, "_on_Level_finished")
	set_process(false)


func _process(delta: float) -> void:
	time += delta
	time_format.format_time(time)


func _on_Level_started() -> void:
	set_process(true)


func _on_Level_finished() -> void:
	set_process(false)
	Events.emit_signal("level_completion_time_emitted", time)
