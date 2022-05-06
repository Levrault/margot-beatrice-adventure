# Manage page's data changes state
# @category: Form
class_name NewProfileForm, "res://assets/icons/form.svg"
extends Form

export var text_input_node_path: NodePath
export var confirm_button_node_path: NodePath
export var previous_page_button_node_path: NodePath

var profile := ""
var profile_data := {}
var profile_name := "" setget _set_profile_name

onready var profile_name_text_input = get_node(text_input_node_path)
onready var confirm_button = get_node(confirm_button_node_path)
onready var previous_page_button = get_node(previous_page_button_node_path)


func _ready() -> void:
	Events.connect("new_profile_page_displayed", self, "_on_New_profile_page_displayed")
	previous_page_button.connect("clicked", self, "reset")


func reset() -> void:
	profile_name_text_input.clear()
	profile = ""
	profile_name = ""
	profile_data = {}


func is_invalid() -> bool:
	return false


func save() -> void:
	profile_data.profile.name = profile_name
	profile_data.profile.created_at = OS.get_unix_time()
	Serialize.save_profile(profile, profile_data)


func _set_profile_name(value: String) -> void:
	if value.length() <= profile_name_text_input.max_length:
		profile_name = value
	else:
		profile_name_text_input.emit_signal("blocked")

	confirm_button.disabled = value.empty()
	profile_name_text_input.text = value


func _on_New_profile_page_displayed(for_profile) -> void:
	profile = for_profile
	profile_data = Serialize.profiles[for_profile]
	confirm_button.disabled = true
	print_debug("Data for %s will be created" % profile)
