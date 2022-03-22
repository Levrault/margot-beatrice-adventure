extends Control

onready var anim := $AnimationPlayer


func next(new_character: String) -> void:
	anim.play("%s_next" % new_character.to_lower())


func prev(new_character: String) -> void:
	anim.play("%s_prev" % new_character.to_lower())
