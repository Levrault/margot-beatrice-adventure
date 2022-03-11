# Load a profile
# @category: Button
extends NavigationButton

onready var profile_name := $MarginContainer/VBoxContainer/Row1/ProfileName
onready var level := $MarginContainer/VBoxContainer/Row1/Level
onready var playtime := $MarginContainer/VBoxContainer/Row2/Playtime
onready var completed := $MarginContainer/VBoxContainer/Row2/Completed


func set_data(data: Dictionary) -> void:
	profile_name.text = data.profile.name

	# TODO: set when real time computing will works
	playtime.text = tr("profile.playtime").format({hours = "00", minutes = "00"})
	level.text = tr("profile.level").format({level = data.progression.last_unlocked_level})
	completed.text = tr("profile.completed").format({percentage = data.progression.completed})


func _on_Pressed() -> void:
	._on_Pressed()
	Game.current_profile = Serialize.PROFILE_SLOTS[owner.get_index()]
	print("%s - %s has been set has current profile" % [Game.current_profile, profile_name.text])
