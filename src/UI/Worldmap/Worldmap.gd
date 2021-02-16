extends NavigationSwitch

onready var characters := $Characters


func _ready() -> void:
	for character in characters.get_children():
		var unlocked = Serialize.data.unlocked_characters.get(character.name)
		if unlocked or character.name == "MargotBeatrice":
			character.anim.play("idle")
			continue

		character.queue_free()
