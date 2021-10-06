extends State


func enter(msg: Dictionary = {}) -> void:
	owner.player_detector.connect("player_entered", self, "_on_Player_entered")
	owner.skin.play("idle")
	if owner.get_parent() is Waypoints and owner.frustrum_culling.is_screen_visible:
		_state_machine.transition_to("Patrol")
		return


func exit() -> void:
	owner.player_detector.disconnect("player_entered", self, "_on_Player_entered")


func _on_Player_entered(player: Player) -> void:
	owner.target = player
	_state_machine.transition_to("Alert")
