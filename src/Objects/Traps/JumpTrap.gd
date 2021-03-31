extends Node2D

onready var _anim := $AnimationPlayer


func _ready():
	$PlayerDetector.connect("player_entered", self, "_on_Player_entered")


func _on_Player_entered(body: Player) -> void:
	_anim.play("on")
	body.state_machine.transition_to("Move/Air", {bouncing_force = 900.0})
