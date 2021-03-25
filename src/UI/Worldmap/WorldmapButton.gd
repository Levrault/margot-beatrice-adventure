extends Button

enum Type { level, cinematic, locked }

export (String) var path := ""
export (Type) var type := Type.level
export (String) var title := "Placeholder"
export (String, MULTILINE) var description := "Placeholder"
export (int) var gems := 0
export (int) var acorns := 0
export (int) var carrots := 0

var _package_data := {}

onready var icon_container = $IconContainer
onready var _anim := $AnimationPlayer


func _ready():
	Serialize.connect("profile_loaded", self, "_on_Profile_loaded")


func change_package_data() -> void:
	Events.emit_signal("worldmap_level_selected", _package_data)


func _on_Focus_entered() -> void:
	_package_data = {"title": title, "description": description}
	$Focus.play()

	if type == Type.level:
		if gems > 0:
			_package_data["gems"] = gems
		if acorns > 0:
			_package_data["acorns"] = acorns
		if carrots > 0:
			_package_data["carrots"] = carrots

	_anim.play("focused")
	Events.emit_signal("worldmap_level_hidden")


func _on_Focus_exited() -> void:
	_anim.play("unfocused")


func _on_Btn_pressed() -> void:
	$Pressed.play()
	AsyncLoading.goto_scene(path)


func _on_Profile_loaded() -> void:
	if is_connected("focus_entered", self, "_on_Focus_entered"):
		disconnect("focus_entered", self, "_on_Focus_entered")
	if is_connected("focus_exited", self, "_on_Focus_exited"):
		disconnect("focus_exited", self, "_on_Focus_exited")
	if is_connected("pressed", self, "_on_Btn_pressed"):
		disconnect("pressed", self, "_on_Btn_pressed")

	if type == Type.level:
		var state = Serialize.data.unlocked_levels.get(path)
		if state != null and state.get("unlocked"):
			connect("focus_entered", self, "_on_Focus_entered")
			connect("focus_exited", self, "_on_Focus_exited")
			connect("pressed", self, "_on_Btn_pressed")
			icon_container.hide()
			return

	if type == Type.cinematic:
		if Serialize.data.unlocked_cinematics.get(path):
			connect("focus_entered", self, "_on_Focus_entered")
			connect("focus_exited", self, "_on_Focus_exited")
			connect("pressed", self, "_on_Btn_pressed")
			text = ""
			icon_container.show()
			icon_container.get_node("Cinema").show()
			return

	icon_container.show()
	icon_container.get_node("Lock").show()
	text = ""
	type = Type.locked
	disabled = true
	focus_mode = FOCUS_NONE
	mouse_default_cursor_shape = CURSOR_ARROW
