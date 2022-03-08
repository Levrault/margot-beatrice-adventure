extends Control

export (String, "profile1", "profile2", "profile3") var selected_profile = "profile1"

onready var button := $Wrapper/Button


func _ready() -> void:
	button.connect("pressed", self, "_on_Button_pressed")
	button.connect("focus_entered", $Focus, "play")

	# has save?
	var save_game = File.new()
	if not save_game.file_exists(Serialize.PATH % [selected_profile]):
		button.text = tr("ui_new_game")
		print_debug("%s is has no associated savefile" % [selected_profile])
		return

	var data := Serialize.quick_read(selected_profile)
	button.text = "%s" % [tr(data["current_level"])]


func _on_Button_pressed() -> void:
	Serialize.profile = selected_profile
	Serialize.load_profile(selected_profile)
	Menu.history.append(owner.get_name())
	Menu.navigate_to("Worldmap")
	$Pressed.play()
	print_debug("%s has change navigation history : %s" % [owner.get_name(), Menu.history])
