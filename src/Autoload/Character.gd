extends Node

enum Playable { FOX, RABBIT, SQUIRREL }
var list := ["Fox", "Rabbit", "Squirrel"]
var selected = Playable.FOX
var score := {
	Playable.FOX: 0,
	Playable.RABBIT: 0,
	Playable.SQUIRREL: 0
}

var hitboxes = {
	Playable.FOX: "FoxCollisionShape",
	Playable.RABBIT: "RabbitCollisionShape",
	Playable.SQUIRREL: "SquirrelCollisionShape",
}


func reset_score() -> void:
	score = {
		Playable.FOX: 0,
		Playable.RABBIT: 0,
		Playable.SQUIRREL: 0
	}


func update_score() -> void:
	score[selected] += 1
	Events.emit_signal("collectable_collected", selected, score[selected])


func get_selected_character_name() -> String:
	return list[selected]


func get_character_name(id: int) -> String:
	return list[id]
