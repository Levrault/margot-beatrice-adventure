extends ParallaxBackground

export (Vector2) var velocity := Vector2(10, 0)


func _process(delta):
	scroll_offset += velocity * delta
