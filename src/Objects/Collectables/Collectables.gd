extends Node2D


func _ready() -> void:
	var gems := 0
	var acorns := 0
	var carrots := 0
	for collectable in get_children():
		if collectable.character == Character.Playable.FOX:
			gems += 1
			continue
		if collectable.character == Character.Playable.SQUIRREL:
			acorns += 1
			continue
		if collectable.character == Character.Playable.RABBIT:
			carrots += 1
			continue
	Events.emit_signal("collectable_max_value_counted", gems, acorns, carrots)
