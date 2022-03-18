extends Node2D

var time := 0.0


func _ready() -> void:
	Events.connect("level_started", self, "_on_Level_started")
	Events.connect("level_finished", self, "_on_Level_finished")
	set_process(false)


func _process(delta: float) -> void:
	time += delta


func _on_Level_started() -> void:
	set_process(true)


func _on_Level_finished() -> void:
	set_process(false)
	print(time)
	Events.emit_signal("level_completion_time_emitted", time)
