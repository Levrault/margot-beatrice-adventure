extends CanvasLayer

var previous_visibility_state := []


func _ready():
	Events.connect("screenshot_started", self, "hide")
	Events.connect("screenshot_ended", self, "show")


func hide() -> void:
	for child in get_children():
		if child.visible:
			previous_visibility_state.append(child.get_name())
		child.visible = false


func show() -> void:
	for child in get_children():
		if previous_visibility_state.has(child.get_name()):
			child.visible = true
