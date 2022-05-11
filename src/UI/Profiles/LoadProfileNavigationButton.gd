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
	playtime.text = tr("profile.playtime").format({time = playtime.seconds2hhmmss(data.stats.total_play_time)})
	level.text = tr("level.%s" % data.progression.last_unlocked_level.to_lower())
	completed.text = tr("profile.completed").format({percentage = completed.format_completed(data.levels)})


func _on_Pressed() -> void:
	._on_Pressed()
	Game.current_profile = Serialize.PROFILE_SLOTS[owner.get_index()]
	print_debug("%s - %s has been set has current profile" % [Game.current_profile, profile_name.text])
