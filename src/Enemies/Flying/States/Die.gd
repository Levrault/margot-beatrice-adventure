extends State


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("die")
	owner.damage_source.is_active = false
	owner.hitbox.is_active = false
	$ExplosionAir.connect("exploded", self, "_on_Exploded")
	$ExplosionAir.start()


func _on_Exploded() -> void:
	owner.queue_free()
	if owner.get_parent() is Waypoints:
		owner.get_parent().queue_free()
