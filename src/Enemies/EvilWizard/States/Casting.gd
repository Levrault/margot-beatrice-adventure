extends State

var projectiles_to_spawn := 0

onready var sfx := $SFXPlayer

func enter(msg: Dictionary = {}) -> void:
	projectiles_to_spawn = _parent.projectiles_spawn_default

	if "laser" in msg:
		owner.skin.connect("animation_finished", self, "_on_Skin_laser_casting_animation_finished")

	if "magic" in msg:
		owner.skin.connect("animation_finished", self, "_on_Skin_magic_casting_animation_finished")

	owner.skin.play("casting")
	sfx.play_sound()


func exit() -> void:
	return


func _on_Skin_laser_casting_animation_finished(anim_name: String) -> void:
	projectiles_to_spawn = projectiles_to_spawn - 1
	_parent.spawn_laser()

	if projectiles_to_spawn <= 0:
		owner.skin.disconnect("animation_finished", self, "_on_Skin_laser_casting_animation_finished")
		_state_machine.transition_to("Attack", {laser = true})
		return

	owner.skin.play("casting")
	sfx.play_sound()


func _on_Skin_magic_casting_animation_finished(anim_name: String) -> void:
	projectiles_to_spawn = projectiles_to_spawn - 1
	_parent.spawn_magic()

	if projectiles_to_spawn <= 0:
		owner.skin.disconnect("animation_finished", self, "_on_Skin_magic_casting_animation_finished")
		_state_machine.transition_to("Attack", {magic = true})
		return

	owner.skin.play("casting")
	sfx.play_sound()
