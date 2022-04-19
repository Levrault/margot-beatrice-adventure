extends State


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("cooldown")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	$Timer.connect("timeout", self, "_on_Timeout")
	$Timer.start()



func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
	$Timer.disconnect("timeout", self, "_on_Timeout")


func _on_Timeout() -> void:
	_state_machine.transition_to("Idle")
