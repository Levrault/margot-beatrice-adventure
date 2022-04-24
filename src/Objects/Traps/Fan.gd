extends Node2D

export var off_time := 1.0
export var on_time := 2.0

onready var _anim = $AnimationPlayer
onready var player_detector := $PlayerDetector


func _ready() -> void:
	$Timer.connect("timeout", self, "_on_Timeout")
	player_detector.connect("player_entered", self, "_on_Player_entered")
	player_detector.connect("player_exited", self, "_on_Player_exited")

	_anim.connect("animation_changed", self, "_on_Animation_changed")
	_anim.play("off")
	$Timer.start()
	$Particles2D.emitting = false


func _on_Animation_changed(old_name: String, new_name: String) -> void:
	if new_name == "on":
		$Timer.wait_time = on_time
		$Timer.start()
		return
	if new_name == "off":
		$Timer.wait_time = off_time
		$Timer.start()
		return


func _on_Timeout() -> void:
	if _anim.current_animation == "on":
		_anim.play("transition_to_off")
		return
	if _anim.current_animation == "off":
		_anim.play("transition_to_on")
		return


func _on_Player_entered(body: Player) -> void:
	if body.state_machine.state_name == "Dash" or body.state_machine.state_name == "Die":
		return
	body.state_machine.transition_to("Move/Floating")


func _on_Player_exited(body: Player) -> void:
	if body.state_machine.state_name == "Dash" or body.state_machine.state_name == "Die":
		return
	body.state_machine.transition_to("Move/Air", {bouncing_force = 200.0, mute_sfx = false})
