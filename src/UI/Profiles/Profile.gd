extends HBoxContainer

onready var load_profile := $LoadProfile
onready var new_profile := $NewProfile
onready var erase := $Erase


func _ready():
	Events.connect("new_profile_created", self, "_on_New_profile_created")
	Events.connect("locale_changed", self, "initialize")
	initialize()


func initialize() -> void:
	if Serialize.profiles[Serialize.PROFILE_SLOTS[get_index()]].profile.name.empty():
		initialize_for_new_profile()
		if get_index() == 0:
			owner.last_clicked_button = new_profile
		return

	initialize_for_existing_profile()
	if get_index() == 0:
		owner.last_clicked_button = load_profile


func initialize_for_new_profile() -> void:
	load_profile.hide()
	erase.hide()
	new_profile.show()


func initialize_for_existing_profile() -> void:
	load_profile.show()
	erase.show()
	new_profile.hide()
	load_profile.set_data(Serialize.profiles[Serialize.PROFILE_SLOTS[get_index()]])


func _on_New_profile_created(profile: String) -> void:
	if profile != Serialize.PROFILE_SLOTS[get_index()]:
		return
	initialize_for_existing_profile()
	owner.last_clicked_button = load_profile
