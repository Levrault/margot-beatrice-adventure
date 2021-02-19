# Pause In game interface
extends Control

var is_active := false
onready var _anim := $AnimationPlayer


func _ready() -> void:
	Events.connect("game_unpaused", self, "_on_Game_unpaused")
	Menu.history.clear()


# Listen to pause input.
# @param {InputEvent} event
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and Menu.history.empty():
		if not is_active:
			is_active = true
			get_tree().paused = true
			_anim.play("open")
			return
		_on_Game_unpaused()
		return

	if event.is_action_pressed("ui_cancel") and Menu.history.size() > 0:
		Menu.navigate_to(Menu.history.pop_back())
		$BackAudio.play()
		return


func _on_Game_unpaused() -> void:
	_anim.play("close")
	is_active = false
	get_tree().paused = false
