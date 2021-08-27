extends State


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("cooldown")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	owner.skin.connect("damage_source_disabled", owner.damage_source, "set_active", [false])
	$Timer.connect("timeout", self, "_on_Timeout")


func exit() -> void:
	owner.skin.disconnect("damage_source_disabled", owner.damage_source, "set_active")
	$Timer.disconnect("timeout", self, "_on_Timeout")


func _on_Skin_animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
	owner.skin.play("idle")
	$Timer.start()


func _on_Timeout() -> void:
	_state_machine.transition_to("Idle")
