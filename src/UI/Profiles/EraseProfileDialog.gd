extends WindowDialog

var profile_to_erase := ""
var associated_erase_button: GenericButton = null

onready var label := $MarginContainer/VBoxContainer/Label
onready var cancel_button = $MarginContainer/VBoxContainer/HBoxContainer/CancelContainer/Cancel
onready var confirm_button := $MarginContainer/VBoxContainer/HBoxContainer/ConfirmContainer/Confirm


func _ready():
	Events.connect("erase_profile_dialog_displayed", self, "_on_Erase_profile_dialog_displayed")
	connect("popup_hide", Events, "emit_signal", ["overlay_hidden"])
	confirm_button.connect("pressed", self, "_on_Confirm_pressed")
	cancel_button.connect("pressed", self, "_on_Cancel_pressed")
	get_close_button().hide()


func show() -> void:
	.show()
	Events.emit_signal("overlay_displayed")
	Events.emit_signal("navigation_disabled")
	confirm_button.grab_focus()


func hide() -> void:
	.hide()
	Events.emit_signal("overlay_hidden")
	Events.emit_signal("navigation_enabled")


func _on_Erase_profile_dialog_displayed(for_profile: String, button: GenericButton) -> void:
	show()
	profile_to_erase = for_profile
	associated_erase_button = button
	label.text = tr("profile.erase_profile").format(
		{profile = Serialize.profiles[profile_to_erase].profile.name}
	)


func _on_Cancel_pressed() -> void:
	associated_erase_button.grab_focus()
	hide()
	profile_to_erase = ""
	associated_erase_button = null


func _on_Confirm_pressed() -> void:
	Events.connect("menu_transition_mid_animated", self, "_on_Menu_transition_mid_animated")
	Events.emit_signal("menu_transition_started", "fade")
	Serialize.erase_profile(profile_to_erase)
	hide()


func _on_Menu_transition_mid_animated() -> void:
	Events.disconnect("menu_transition_mid_animated", self, "_on_Menu_transition_mid_animated")
	associated_erase_button.owner.initialize_for_new_profile()
	associated_erase_button.owner.new_profile.call_deferred("grab_focus")
	profile_to_erase = ""
	associated_erase_button = null
