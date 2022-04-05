extends Control

# miliseconds
export var time_for_rank_100 := 30000.0
export var time_for_rank_80 := 45000.0
export var time_for_rank_60 := 60000.0

onready var _anim := $AnimationPlayer


func _ready():
	Events.connect("level_finished", self, "_on_Level_finished")


func _on_Level_finished() -> void:
	_anim.play("show")
