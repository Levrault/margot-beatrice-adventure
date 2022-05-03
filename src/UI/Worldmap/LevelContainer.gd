extends HBoxContainer


func _ready():
	owner.connect("navigation_finished", self, "_on_Navigation_finished")


func _on_Navigation_finished() -> void:
	yield(get_tree(), "idle_frame")

	for child in get_children():
		if child.get_name() == Serialize.profiles[Game.current_profile].progression.last_unlocked_level:
			child.load_level_button.call_deferred("grab_focus")
