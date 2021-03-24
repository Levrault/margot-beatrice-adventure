extends Control

onready var _anim := $AnimationPlayer


func _ready():
	Events.connect("level_finished", self, "_on_Level_finished")


func _on_Level_finished() -> void:
	_anim.play("show")
