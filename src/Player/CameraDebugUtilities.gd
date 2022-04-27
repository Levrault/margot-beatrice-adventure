extends Node2D

export (Color) var color = Color(255, 255, 255, 255)


func _ready() -> void:
	if not Project.get_setting("camera_anchor"):
		queue_free()


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	if not SceneManager.anchor:
		return
	var anchor_position := to_local(SceneManager.anchor.global_position)
	draw_line(anchor_position, position, color, 1)
	draw_circle(anchor_position, 5, color)
	draw_circle(position, 2, color)
	update()
