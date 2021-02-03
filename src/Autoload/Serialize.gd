# Load and save progression
extends Node

const DEBUG_SAVE := "debug1"
const PATH := "user://%s.save"
const DEFAULT_DATA := {"level": "demo", "room": "Room1", "abilities": {}}
var profile := "profile1" setget set_profile
var _path := PATH % [profile]


func _ready() -> void:
	# force debug profile
	if ProjectSettings.get_setting("game/debug"):
		self.profile = DEBUG_SAVE

	if ProjectSettings.get_setting("game/load_save"):
		load_profile(profile)


func set_profile(new_profile: String) -> void:
	print_debug(new_profile)
	profile = new_profile
	_path = PATH % [new_profile]


func save_profile(data: Dictionary, should_send_signal: bool = true) -> void:
	var save_dict = {"level": data["level"], "room": data["room"], "abilities": data["abilities"]}
	var file_profile = File.new()
	file_profile.open(_path, File.WRITE)
	file_profile.store_line(to_json(save_dict))
	file_profile.close()
	print_debug("%s has been saved" % [profile])

	if should_send_signal:
		Events.emit_signal("game_saved")


func quick_read(selected_profile: String) -> Dictionary:
	var save = File.new()
	if not save.file_exists(_path):
		save_profile(DEFAULT_DATA, false)
		print_debug("LOADING FAILED: create a new save data for %s" % [selected_profile])
	save.open(PATH % [selected_profile], File.READ)
	var data: Dictionary = parse_json(save.get_line())
	return data


# is _path independent.
func load_profile(selected_profile: String) -> Dictionary:
	var save = File.new()
	if not save.file_exists(_path):
		save_profile(DEFAULT_DATA, false)
		print_debug("LOADING FAILED: create a new save data for %s" % [selected_profile])

	save.open(_path, File.READ)
	var data: Dictionary = parse_json(save.get_line())

	# set abilities
	Game.unlocked_abilities = data["abilities"]

	save.close()
	print_debug("%s has been loaded" % [profile])

	return data
