extends Control

# miliseconds
export var time_for_rank_100 := 30000.0
export var time_for_rank_80 := 45000.0
export var time_for_rank_60 := 60000.0

var current_level := ""
var next_level := ""

onready var _anim := $AnimationPlayer


func _ready():
	Events.connect("level_finished", self, "_on_Level_finished")
	current_level = owner.get_name().to_lower()
	next_level = owner.next_level


func _on_Level_finished() -> void:
	_anim.play("show")
