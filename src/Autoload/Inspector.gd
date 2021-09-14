tool
extends Node

var editor_interface = null


func _enter_tree() -> void:
	if not Engine.editor_hint:
		return

	var plugin = EditorPlugin.new()
	editor_interface = plugin.get_editor_interface()  # now you always have the interface
	plugin.queue_free()


func _ready() -> void:
	if not Engine.editor_hint:
		queue_free()
