extends Control

export var time_for_rank_100 := 0.0
export var time_for_rank_80 := 0.0
export var time_for_rank_60 := 0.0

onready var _anim := $AnimationPlayer


func _ready():
	Events.connect("level_finished", self, "_on_Level_finished")


func _on_Level_finished() -> void:
	_anim.play("show")
