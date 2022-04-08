tool
extends Node2D

export (Color) var color = Color(255, 255, 0, 255)
export (Color) var selected_color = Color(255, 0, 0, 255)

var drawing_color = color
var drawing_width := 2


func _ready() -> void:
	if not Engine.editor_hint:
		queue_free()
		return


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	var half_screen = owner.screen_size / 2
	var low_point = -half_screen
	var hight_point = half_screen
	draw_line(low_point, Vector2(hight_point.x, low_point.y), drawing_color, drawing_width)
	draw_line(Vector2(hight_point.x, low_point.y), hight_point, drawing_color, drawing_width)
	draw_line(hight_point, Vector2(low_point.x, hight_point.y), drawing_color, drawing_width)
	draw_line(Vector2(low_point.x, hight_point.y), low_point, drawing_color, drawing_width)
	update()
