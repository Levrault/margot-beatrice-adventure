# Detect NPC and manage interactions the player can
# have with them
extends Area2D

enum States { IDLE, PENDING, CONTINUING, CHOOSING, ENDING }

var _npc: Npc = null
var _state = States.IDLE


# Init detect zone and linh change state to the dialogueBox
func _ready() -> void:
	Events.connect("dialogue_last_text_displayed", self, "_on_State_changed", [States.ENDING])
	Events.connect("dialogue_text_displayed", self, "_on_State_changed", [States.CONTINUING])
	Events.connect("dialogue_choices_displayed", self, "_on_State_changed", [States.CHOOSING])
	Events.connect("dialogue_choices_pressed", self, "_on_State_changed", [States.PENDING])
	Events.connect("dialogue_timed_out", self, "_on_State_changed", [States.PENDING])
	connect("body_entered", self, "_on_Npc_entered")
	connect("body_exited", self, "_on_Npc_exited")
	set_process_unhandled_input(false)


# Start, skip, end dialogue
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction"):
		_interact()
		return
	# allow jump to display next when dialogue is enable
	if not _state == States.IDLE and event.is_action_pressed("jump"):
		_interact()
		return


# Is possible to interact with the npc
# @param {Npc} body
func _on_Npc_entered(body: Npc) -> void:
	set_process_unhandled_input(true)
	_npc = body
	_npc.is_interactable = true

	if _npc.is_auto_trigger:
		_interact()


# Is no longer possible to interact with the npc
# @param {Npc} body
func _on_Npc_exited(body: Npc) -> void:
	body.is_interactable = false
	set_process_unhandled_input(false)
	_npc = null


# Change Npc's interaction state
# @param {int} value - should be valid State's enum value
func _on_State_changed(value: int) -> void:
	_state = value


func _interact() -> void:
	# last dialogue/interaction was displayed, end the interaction
	if _state == States.ENDING:
		owner.is_handling_input = true
		owner.character_factory.set_process_unhandled_input(true)
		_npc.is_in_interaction = false
		_state = States.IDLE
		Events.emit_signal("dialogue_finished")
		return

	# interaction with npc has begun
	if not _npc.is_in_interaction:
		owner.is_handling_input = false
		owner.character_factory.set_process_unhandled_input(false)
		_npc.is_in_interaction = true
		_state = States.PENDING
		return

	if _state == States.CONTINUING:
		_npc.next_interaction()
		_state = States.PENDING
		return

	if _state == States.CHOOSING:
		return

	# call next interaction
	Events.emit_signal("dialogue_animation_skipped")
