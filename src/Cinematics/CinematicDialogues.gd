extends Node2D

enum States { IDLE, PENDING, CONTINUING, CHOOSING, ENDING }

var dialogue_controller = null
var _state = States.IDLE


# Init detect zone and link change state to the dialogueBox
func _ready() -> void:
	yield(owner, "ready")
	Events.connect("dialogue_last_text_displayed", self, "_on_State_changed", [States.ENDING])
	Events.connect("dialogue_text_displayed", self, "_on_State_changed", [States.CONTINUING])
	Events.connect("dialogue_choices_displayed", self, "_on_State_changed", [States.CHOOSING])
	Events.connect("dialogue_choices_pressed", self, "_on_State_changed", [States.PENDING])
	Events.connect("dialogue_timed_out", self, "_on_State_changed", [States.PENDING])


# Start, skip, end dialogue
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and dialogue_controller != null:
		_interact()
		return


# @param {int} value - should be valid State's enum value
func _on_State_changed(value: int) -> void:
	_state = value


func _interact() -> void:
	# last dialogue/interaction was displayed, end the interaction
	if _state == States.ENDING:
		_state = States.IDLE
		Events.emit_signal("dialogue_finished")
		owner.anim.play(dialogue_controller.next_sequence)
		dialogue_controller = null;
		return

	if _state == States.CONTINUING:
		dialogue_controller.next()
		_state = States.PENDING
		return

	if _state == States.CHOOSING:
		return

	# call next interaction
	Events.emit_signal("dialogue_animation_skipped")
