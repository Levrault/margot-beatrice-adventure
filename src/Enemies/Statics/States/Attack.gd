extends State


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("attack")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	owner.skin.connect("damage_source_enabled", owner.damage_source, "set_active", [true])
	owner.skin.connect("damage_source_disabled", owner.damage_source, "set_active", [false])


func exit() -> void:
	owner.skin.disconnect("damage_source_enabled", owner.damage_source, "set_active")
	owner.skin.disconnect("damage_source_disabled", owner.damage_source, "set_active")
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")


func _on_Skin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Cooldown")
