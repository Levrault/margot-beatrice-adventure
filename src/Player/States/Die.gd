extends State

onready var sfx := $Sfx


func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	if owner.camera_rig:
		owner.camera_rig.is_active = false

	sfx.play()
	owner.skin.play("die")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	owner.stats.set_invulnerable_for_seconds(2)
	if InputManager.is_using_gamepad():
		Input.start_joy_vibration(0, Config.values.gamepad_layout.gamepad_vibration, Config.values.gamepad_layout.gamepad_vibration, .450)


func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")


func _on_Skin_animation_finished(anim_name: String) -> void:
	Game.stats.game_over += 1
	_state_machine.transition_to("Spawn")
