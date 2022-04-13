extends ParallaxLayer

export (Vector2) var velocity := Vector2(-15, 0)


func _process(delta):
	motion_offset += velocity * delta
