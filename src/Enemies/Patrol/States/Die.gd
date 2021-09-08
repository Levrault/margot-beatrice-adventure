extends State


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("die")
	owner.damage_source.is_active = false
	owner.hitbox.is_active = false
	$Explosion.connect("exploded", self, "_on_Exploded")
	$Explosion.start()


func _on_Exploded() -> void:
	owner.queue_free()
