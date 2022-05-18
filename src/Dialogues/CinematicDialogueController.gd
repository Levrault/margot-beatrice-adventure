# Owner dependant
# Read associated dialogue json file to NPC
# Based on NPC name
# Order and manage which dialogue is send to DialogueBox
extends DialogueController

export var next_sequence := ""


func load_json() -> void:
	dialogue_json = JsonReader.get_json("res://assets/dialogues/%s.json" % [get_name()])


func start() -> void:
	get_parent().dialogue_controller = self
	Events.emit_signal("dialogue_started")
	_current_dialogue = get_next(dialogue_json.root)
	change()
	owner.set_process_unhandled_input(true)
