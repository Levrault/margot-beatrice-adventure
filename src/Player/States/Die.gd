extends State


onready var sfx := $Sfx


func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	if owner.camera_rig:
		owner.camera_rig.is_active = false

	sfx.play()
	owner.skin.play("die")
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")


func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")


func _on_Skin_animation_finished(anim_name: String) -> void:
	Game.stats.game_over += 1
	_state_machine.transition_to("Spawn")
