extends Control


func next(new_character: String) -> void:
	$AnimationPlayer.play("%s_next" % new_character.to_lower())


func prev(new_character: String) -> void:
	$AnimationPlayer.play("%s_prev" % new_character.to_lower())
