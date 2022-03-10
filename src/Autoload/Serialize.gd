# Load and save progression
extends Node

const PROFILE_TEMPLATE_PATH := "res://engine/profile_template.cfg"
const PROFILE_SLOTS := ["profile0", "profile1", "profile2"]
const SAVE_PATH := "user://%s.save"

var profiles := {}
var template := {}


func _ready() -> void:
	initialize()
	load_profiles()


# Create all profile slots
func initialize() -> void:
	var profile_template := ConfigFile.new()
	var err = profile_template.load(PROFILE_TEMPLATE_PATH)
	if err == ERR_FILE_NOT_FOUND:
		printerr("%s was not found" % [PROFILE_TEMPLATE_PATH])
		return
	if err != OK:
		printerr("%s has encounter an error: %s" % [PROFILE_TEMPLATE_PATH, err])
		return

	for section in profile_template.get_sections():
		template[section] = {}
		for key in profile_template.get_section_keys(section):
			template[section][key] = profile_template.get_value(section, key, null)

	for profile in PROFILE_SLOTS:
		var profile_file = File.new()
		if profile_file.file_exists(SAVE_PATH % profile):
			continue
		profile_file.open(SAVE_PATH % profile, File.WRITE)
		profile_file.store_line(to_json(template.duplicate(true)))
		profile_file.close()
	print_debug("Profiles are created")


func load_profiles() -> void:
	for profile in PROFILE_SLOTS:
		var profile_file = File.new()
		profile_file.open(SAVE_PATH % profile, File.READ)
		profiles[profile] = sync(profile, parse_json(profile_file.get_line()), template.duplicate(true))
	print_debug("Profiles are loaded : ", profiles)


# sync current profile with profile_template
func sync(slot:String, profile: Dictionary, template: Dictionary) -> Dictionary:
	var has_changed := false
	# sync new data
	for section in template.keys():
		if not profile.has(section):
			profile[section] = {}

		for key in template[section].keys():
			if not profile[section].has(key):
				profile[section][key] = template[section][key]
				has_changed = true
				continue

			if typeof(template[section][key]) == TYPE_DICTIONARY:
				for inner_key in template[section][key].keys():
					if not profile[section][key].has(inner_key):
						profile[section][key][inner_key] = template[section][key][inner_key]
						has_changed = true
				continue

	# remove unused data
	for section in profile.keys():
		if not template.has(section):
			profile.erase(section)
			continue
		for key in profile[section].keys():
			if not template[section].has(key):
				profile[section].erase(key)
				has_changed = true
				continue

			if typeof(profile[section][key]) == TYPE_DICTIONARY:
				for inner_key in profile[section][key].keys():
					if not template[section][key].has(inner_key):
						profile[section][key].erase(inner_key)
						has_changed = true
				continue

	if has_changed:
		save_profile(slot, profile)
	return profile


func save_profile(profile_name: String, values: Dictionary) -> void:
	var profile_file := File.new()
	if not profile_file.file_exists(SAVE_PATH % profile_name):
		printerr("%s save file doesn't exist" % profile_name)
		return

	profile_file.open(SAVE_PATH % profile_name, File.WRITE)
	profile_file.store_line(to_json(values))
	profile_file.close()


func erase(profile_name: String) -> void:
	var profile_file := File.new()
	profile_file.open(SAVE_PATH % profile_name, File.WRITE)
	profile_file.store_line(to_json(template.duplicate(true)))
	profile_file.close()
	print_debug("%s save has been erased")
