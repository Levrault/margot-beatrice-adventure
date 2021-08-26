extends State


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("die")
	$Explosion.connect("exploded", self, "_on_Exploded")
	$Explosion.start()


func _on_Exploded() -> void:
	owner.queue_free()
