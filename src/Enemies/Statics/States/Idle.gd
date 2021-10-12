extends State


func enter(msg: Dictionary = {}) -> void:
	$PlayerDetector.connect("player_entered", self, "_on_Player_detected")
	$PlayerDetector.disabled = false
	owner.skin.play("idle")
	owner.damage_source.is_active = false


func exit() -> void:
	$PlayerDetector.disconnect("player_entered", self, "_on_Player_detected")
	$PlayerDetector.disabled = true


func _on_Player_detected(body: Player) -> void:
	_state_machine.transition_to("Attack")
