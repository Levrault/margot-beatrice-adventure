extends Control

# miliseconds
export var time_for_rank_100 := 30.0
export var time_for_rank_80 := 45.0
export var time_for_rank_60 := 60.0

var current_level := ""
var next_level := ""

onready var _anim := $AnimationPlayer


func _ready():
	Events.connect("level_finished", self, "_on_Level_finished")
	current_level = owner.get_name()
	next_level = owner.next_level

	time_for_rank_100 *= 1000
	time_for_rank_80 *= 1000
	time_for_rank_60 *= 1000


func _on_Level_finished() -> void:
	_anim.play("show")
