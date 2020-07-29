extends Node

enum Playable { fox, rabbit, squirrel }
var list := ["Fox", "Rabbit", "Squirrel"]
var selected = Playable.fox
var score := {
	Playable.fox: 0,
	Playable.rabbit: 0,
	Playable.squirrel: 0,
}


func update_score() -> void:
	score[selected] += 1
	Events.emit_signal("collectable_collected", selected, score[selected])


func get_selected_character_name() -> String:
	return list[selected]
