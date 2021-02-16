# Quit application
extends Button

onready var _anim := $AnimationPlayer


func _ready() -> void:
	connect("pressed", self, "_on_Pressed")
	connect("focus_entered", self, "_on_Focus_entered")
	connect("focus_exited", self, "_on_Focus_exited")


func _on_Pressed() -> void:
	get_tree().quit()


func _on_Focus_entered() -> void:
	_anim.play("focused")


func _on_Focus_exited() -> void:
	_anim.play("unfocused")
