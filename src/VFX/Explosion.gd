# Explosion BOOM BOOM
extends Node2D

signal exploded


func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "_on_Animation_finished")


# Start explosion
func start() -> void:
	show()
	$AnimationPlayer.play("explode")
	$AudioStreamPlayer2D.play()


# @signal animation_finished
# @emit exploded
# @param {String} anim_name
func _on_Animation_finished(anim_name: String) -> void:
	assert(anim_name == "explode")
	emit_signal("exploded")
	hide()
