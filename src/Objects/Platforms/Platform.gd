tool
extends KinematicBody2D
class_name Platform

export var speed := 50.0
export var wait_time := 1.0 setget set_wait_time

onready var timer := $Timer
onready var tween := $Tween
onready var waypoints = get_parent()
onready var _player_detector := $PlayerDetector


func _ready() -> void:
	if not waypoints is Line2D:
		return

	# be sure we start at the first point
	position = waypoints.get_start_position()

	if Engine.editor_hint:
		return

	_player_detector.connect("player_entered", self, "_on_Player_entered")
	_player_detector.connect("player_exited", self, "_on_Player_exited")
	timer.connect("timeout", self, "_on_Timeout")
	tween.connect("tween_all_completed", self, "_on_Tween_all_completed")
	timer.start()


func set_wait_time(value: float) -> void:
	wait_time = value
	if not timer:
		yield(self, "ready")

	if wait_time == 0:
		wait_time = 0.01
	timer.wait_time = wait_time


func _on_Timeout() -> void:
	var target_position: Vector2 = waypoints.get_next_point_position()
	var distance_to_target := position.distance_to(target_position)
	tween.interpolate_property(
		self, "position", position, target_position, distance_to_target / speed
	)
	tween.start()


func _on_Tween_all_completed() -> void:
	timer.start()


func _on_Player_entered(body: Player) -> void:
	body.is_snapped_to_floor = true
	body.stop_on_slope = false


func _on_Player_exited(body: Player) -> void:
	body.is_snapped_to_floor = false
	body.stop_on_slope = true
