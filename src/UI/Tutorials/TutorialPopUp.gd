extends Control
class_name TutorialPopUp

export var duration := .75

onready var panel := $Panel
onready var panel_container := $PanelContainer
onready var anim := $AnimationPlayer
onready var tween := $Tween


func _ready():
	Events.connect("room_limit_changed", self, "_on_Room_limit_changed")
	tween.connect("tween_all_completed", self, "_on_Tween_all_completed")
	panel_container.hide()
	panel.hide()
	panel.rect_size = Vector2.ZERO


func _on_Room_limit_changed(bounds: Dictionary) -> void:
	if (
		rect_position.y > bounds.limit_bottom
		or rect_position.y < bounds.limit_top
		or rect_position.x < bounds.limit_left
		or rect_position.x > bounds.limit_right
	):
		return

	Events.disconnect("room_limit_changed", self, "_on_Room_limit_changed")
	tween.interpolate_property(
		panel,
		"rect_size",
		Vector2(panel_container.rect_size.x, 0),
		panel_container.rect_size,
		duration,
		Tween.TRANS_BOUNCE,
		Tween.TRANS_LINEAR
	)
	tween.interpolate_property(
		panel, "modulate:a", 0.2, 1.0, duration, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT
	)
	tween.start()
	panel.show()


func _on_Tween_all_completed() -> void:
	tween.disconnect("tween_all_completed", self, "_on_Tween_all_completed")
	panel.hide()
	panel_container.show()
