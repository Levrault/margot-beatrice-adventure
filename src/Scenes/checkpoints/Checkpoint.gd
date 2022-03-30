# Manage checkpoint
extends Node2D
class_name Checkpoint


onready var anim := $AnimationPlayer
onready var player_detector := $PlayerDetector
onready var spawn_position := $Position2D


func _ready():
	anim.play("Inactive")
	player_detector.connect("player_entered", self, "_on_Player_enter")


# Set new player checkpoint
# @param {Player} body
func _on_Player_enter(body: Player) -> void:
	assert(body is Player)
	player_detector.disconnect("player_entered", self, "_on_Player_enter")
	anim.play("Transition")
	Events.emit_signal("spawn_position_changed", spawn_position.global_position)
