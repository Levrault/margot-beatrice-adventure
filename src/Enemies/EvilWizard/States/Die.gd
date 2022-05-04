extends State


onready var sfx := $SFXPlayer


func unhandled_input(event: InputEvent) -> void:
	return


func physics_process(delta: float) -> void:
	return


func enter(msg: Dictionary = {}) -> void:
	owner.skin.connect("animation_finished", self, "_on_Die_animation_finished")
	owner.skin.play("die")
	owner.damage_source.is_active = false
	owner.hitbox.is_active = false
	sfx.play_sound()
	$Explosion.connect("exploded", self, "_on_Exploded")
	$Explosion.start()


func _on_Die_animation_finished(anim_name: String) -> void:
	owner.queue_free()
