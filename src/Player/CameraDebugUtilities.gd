extends Node2D

export (Color) var color = Color(255, 255, 255, 255)
export (bool) var is_active = true


func _ready() -> void:
	if not is_active:
		queue_free()


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	var anchor_position := to_local(RoomManager.anchor.global_position)
	draw_line(anchor_position, position, color, 1)
	draw_circle(anchor_position, 5, color)
	draw_circle(position, 2, color)
	update()
