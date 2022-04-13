extends Node
class_name ScoreContainer

onready var _tween := $Tween
onready var _score := $Score


func _format_text(value: int) -> void:
	_score.text = String(value)
