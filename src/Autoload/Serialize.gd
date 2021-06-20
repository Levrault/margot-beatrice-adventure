# Load and save progression
extends Node

signal profile_loaded

const DEBUG_SAVE := "debug1"
const PATH := "user://%s.save"

var default_data := {
	"game_version": ProjectSettings.get_setting("game/game_version"),
	"progression": 0,
	"last_played": "intro",
	"current_level": "demo",
	"unlocked_cinematics":
	{
		"res://src/Levels/Debug/DebugCinematic.tscn": false,
	},
	"unlocked_levels":
	{
		"res://src/Levels/Debug/TestRoom.tscn":
		{
			"unlocked": true,
			"collectables":
			{
				"gems": 4,
				"acorns": 4,
				"carrots": 4,
			}
		},
	},
	"unlocked_characters":
	{
		"fox": true,
		"squirrel": false,
		"rabbit": false,
	},
	"stats":
	{
		"game_over": 0,
		"hits": 0,
		"play_time": 0,
	}
}
var profile := "profile1" setget set_profile
var data := {}
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
	var save_dict = default_data
	var file_profile = File.new()
	file_profile.open(_path, File.WRITE)
	file_profile.store_line(to_json(save_dict))
	file_profile.close()
	print_debug("%s has been saved" % [profile])

	if should_send_signal:
		Events.emit_signal("game_saved")


# is _path independent.
func load_profile(selected_profile: String) -> void:
	var save = File.new()

	if not save.file_exists(_path):
		save_profile(default_data, false)
		print_debug("LOADING FAILED: create a new save data for %s" % [selected_profile])

	save.open(_path, File.READ)
	data = parse_json(save.get_line())

	# set character
	Game.unlocked_characters = data.unlocked_characters
	Game.stats = data.stats

	save.close()

	emit_signal("profile_loaded")

	print_debug("save_file version is %s" % [data.game_version])
	print_debug("%s has been loaded" % [profile])


func quick_read(selected_profile: String) -> Dictionary:
	var save = File.new()
	if not save.file_exists(_path):
		save_profile(default_data, false)
		print_debug("LOADING FAILED: create a new save data for %s" % [selected_profile])
	save.open(PATH % [selected_profile], File.READ)
	var data: Dictionary = parse_json(save.get_line())
	return data
