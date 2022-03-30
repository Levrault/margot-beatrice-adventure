extends State

var spawn_position := Vector2.ZERO


func _ready() -> void:
	yield(owner, "ready")
	Events.connect("spawn_position_changed", self, "_on_Spawn_position_changed")
	spawn_position = owner.position


func enter(msg: Dictionary = {}) -> void:
	owner.position = spawn_position
	owner.is_active = false
	owner.stats.reset()
	if owner.camera_rig:
		owner.camera_rig.is_active = false

	owner.skin.play("spawn")

	# check needed since skin value is changed on character change
	if not owner.skin.is_connected("animation_finished", self, "_on_Skin_animation_finished"):
		owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")


func exit() -> void:
	owner.is_active = true

	# check needed since skin value is changed on character change
	if owner.skin.is_connected("animation_finished", self, "_on_Skin_animation_finished"):
		owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")


func _on_Skin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to("Move/Idle")


func _on_Spawn_position_changed(new_position: Vector2) -> void:
	spawn_position = new_position
