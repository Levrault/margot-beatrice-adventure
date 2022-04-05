# Explosion BOOM BOOM
extends Node2D

signal exploded

onready var anim := $AnimationPlayer
onready var audio := $AudioStreamPlayer


func _ready() -> void:
	anim.connect("animation_finished", self, "_on_Animation_finished")


# Start explosion
func start() -> void:
	show()
	anim.play("explode")
	audio.play()


# @signal animation_finished
# @emit exploded
# @param {String} anim_name
func _on_Animation_finished(anim_name: String) -> void:
	assert(anim_name == "explode")
	emit_signal("exploded")
	hide()
