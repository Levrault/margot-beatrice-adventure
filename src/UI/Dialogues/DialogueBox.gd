# Receive and display dialogue between player and Npc
extends Control

enum States { PENDING, QUESTIONNING }

var _choice_btn_scene := preload("res://src/UI/Dialogues/ChoicesBtn.tscn")
var _message := ''
var _is_last_dialogue := false
var _state: int = States.PENDING

onready var _anim_dialogue := $AnimationPlayerDialogue
onready var _anim_actions := $AnimationPlayerActions
onready var _anim_choices := $AnimationPlayerChoices
onready var _text := $Panel/Wrapper/Contents/Message
onready var _name := $Panel/NameContent/MarginContainer/Name
onready var _portrait := $Panel/Wrapper/Contents/Portrait
onready var _choices_panel := $Choices
onready var _choices_contents := $Choices
onready var _next := $Next
onready var _end := $End
onready var _timer := $Timer


func _ready() -> void:
	Events.connect("dialogue_started", self, "_on_Dialogue_started")
	Events.connect("dialogue_changed", self, "_on_Dialogue_changed")
	Events.connect("dialogue_finished", self, "_on_Dialogue_finished")
	Events.connect("dialogue_last_dialogue_displayed", self, "_on_Last_dialogue")
	Events.connect("dialogue_choices_changed", self, "_on_Choice_changed")
	Events.connect("dialogue_timed", self, "_on_Timed_changed")
	_timer.connect("timeout", self, "_on_Timeout")

	_next.hide()
	_end.hide()
	_choices_panel.hide()

	set_process_unhandled_input(false)


# Show/hide action button and manage when this is the last dialogue box
# that need to be displayed
func next_action() -> void:
	if _state == States.QUESTIONNING:
		_anim_choices.play("show")
		_choices_contents.get_child(0).grab_focus()
		Events.emit_signal("dialogue_choices_displayed")
		_next.show()
		_anim_actions.play("next")
		return

	if _is_last_dialogue and _state == States.PENDING:
		Events.emit_signal("dialogue_last_text_displayed")
		_next.hide()
		_end.show()
		_anim_actions.play("end")
		return

	Events.emit_signal("dialogue_text_displayed")
	_next.show()
	_anim_actions.play("next")


# show dialogue box
func _on_Dialogue_started() -> void:
	_anim_dialogue.play("show")


# Convert text to bb_code, start text animation
# @param {String} message
func _on_Dialogue_changed(name: String, portrait: StreamTexture, message: String) -> void:
	_timer.stop()
	_message = message
	_name.text = name
	_portrait.texture = portrait
	_text.visible_characters = 0
	_text.parse_bbcode(message)
	_text.toggle_animation(true)


# Add and display player's choice
# @param {Array} choices
func _on_Choice_changed(choices: Array) -> void:
	_state = States.QUESTIONNING
	for choice in choices:
		var button: Button = _choice_btn_scene.instance()
		button.text = choice["text"][TranslationServer.get_locale()]
		button.connect("pressed", self, "_on_Choice_pressed", [choice["next"]])
		_choices_contents.add_child(button)


func _on_Choice_pressed(next: String) -> void:
	for choice in _choices_contents.get_children():
		choice.queue_free()
	_state = States.PENDING
	_choices_panel.hide()
	Events.emit_signal("dialogue_choices_finished", next)
	Events.emit_signal("dialogue_choices_pressed")


# Reset dialogue
func _on_Dialogue_finished() -> void:
	_anim_dialogue.play("hide")
	_timer.stop()
	_choices_panel.hide()
	_is_last_dialogue = false
	_text.toggle_animation(false)


# Last dialogue box has been displayed
# Is managed by DialogueController
func _on_Last_dialogue() -> void:
	_is_last_dialogue = true


# Timer controlled dialogue
# @param {float} time_left
func _on_Timed_changed(time_left: float) -> void:
	_timer.start(time_left)


# Hide and tell the player that dialogue box has timed out
func _on_Timeout() -> void:
	_on_Dialogue_finished()
	Events.emit_signal("dialogue_timed_out")
