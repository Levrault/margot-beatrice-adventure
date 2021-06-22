extends Label

export (Character.Playable) var character = Character.Playable.FOX


func _ready() -> void:
	Events.connect("collectable_collected", self, "_on_Collectable_collected")


func _on_Collectable_collected(selected_character: int, score: int) -> void:
	if selected_character != character:
		return
	owner.content.show()
	text = "%s" % score
