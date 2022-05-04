extends State


onready var timer := $Timer


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	timer.connect("timeout", self, "_on_Timeout")
	$ExclamationPoint.anim.play("show")
	owner.skin.play("vulnerable")
	owner.hitbox.is_active = true
	owner.damage_source.is_active = false
	timer.start()


func exit() -> void:
	timer.disconnect("timeout", self, "_on_Timeout")
	owner.hitbox.is_active = false
	owner.damage_source.is_active = true


func _on_Timeout() -> void:
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	owner.skin.anim.play_backwards("vulnerable")


func _on_Skin_animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
	_state_machine.transition_to("Attack/Casting", {laser = true})
