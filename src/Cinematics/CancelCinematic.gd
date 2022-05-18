extends Control

export var active := true

var duration := 1.0
var default_modulate_alpha := modulate.a

onready var timer := $Timer
onready var tween := $Tween
onready var altas_icon := $VBoxContainer/HBoxContainer/InteractableAtlasIcon
onready var progress_bar := $VBoxContainer/ProgressBar


func _ready():
	if not active:
		queue_free()
	Events.connect("screenshot_started", self, "hide")
	Events.connect("screenshot_ended", self, "show")
	timer.connect("timeout", self, "_on_Timeout")
	duration = timer.wait_time


func _unhandled_input(event) -> void:
	if event.is_action_pressed("interaction"):
		tween.interpolate_property(progress_bar, "value", 0, 100, duration)
		tween.interpolate_property(self, "modulate:a", default_modulate_alpha, 1.0, .25)
		tween.start()
		timer.start()
		return
	if event.is_action_released("interaction"):
		timer.stop()
		tween.stop_all()
		tween.remove_all()
		tween.interpolate_property(self, "modulate:a", 1.0, default_modulate_alpha, duration / 2)
		tween.interpolate_property(progress_bar, "value", progress_bar.value, 0, .25)
		progress_bar.value = 0
		tween.start()
		return


func _on_Timeout() -> void:
	owner.stop()
	set_process_unhandled_input(false)
