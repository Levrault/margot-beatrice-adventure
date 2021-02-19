class_name AnimatedButton
extends Button

onready var _anim := $AnimationPlayer


func _ready():
	connect("focus_entered", self, "_on_Focus_entered")
	connect("focus_exited", self, "_on_Focus_exited")


func _on_Focus_entered() -> void:
	_anim.play("focus")
	$FocusAudio.play()


func _on_Focus_exited() -> void:
	_anim.play("unfocus")
