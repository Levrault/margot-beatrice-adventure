extends State


func enter(msg: Dictionary = {}) -> void:
	$PlayerDetector.connect("player_entered", self, "_on_Player_detected")
	$PlayerDetector.disabled = false
	$Timer.connect("timeout", self, "_on_Timeout")
	owner.skin.play("idle")
	owner.damage_source.is_active = false


func exit() -> void:
	$PlayerDetector.disconnect("player_entered", self, "_on_Player_detected")
	$Timer.disconnect("timeout", self, "_on_Timeout")
	$PlayerDetector.disabled = true


func _on_Player_detected(body: Player) -> void:
	$Timer.start()


func _on_Timeout() -> void:
	_state_machine.transition_to("Attack")
	$Timer.stop()
