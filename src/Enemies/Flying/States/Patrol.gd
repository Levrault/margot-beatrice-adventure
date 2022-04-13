extends State

export var speed := 50.0
export var wait_time := 0.5 setget set_wait_time

onready var _timer := $Timer
onready var _tween := $Tween
onready var _waypoints = owner.get_parent()


func set_wait_time(value: float) -> void:
	wait_time = value
	if not _timer:
		yield(self, "ready")

	if wait_time == 0:
		wait_time = 0.01
	_timer.wait_time = wait_time


func enter(msg: Dictionary = {}) -> void:
	owner.player_detector.connect("player_entered", self, "_on_Player_entered")
	_timer.connect("timeout", self, "_on_Timeout")
	_tween.connect("tween_all_completed", self, "_on_Tween_all_completed")

	# must be activated to follow the waypoints
	owner.set_sync_to_physics(true)
	_tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	_waypoints.reset()

	owner.skin.play("idle")
	_timer.start()


func exit() -> void:
	owner.set_sync_to_physics(false)
	owner.player_detector.disconnect("player_entered", self, "_on_Player_entered")
	_timer.disconnect("timeout", self, "_on_Timeout")
	_tween.disconnect("tween_all_completed", self, "_on_Tween_all_completed")

	_tween.stop_all()
	_tween.remove_all()
	_timer.stop()


func _on_Timeout() -> void:
	var target_position: Vector2 = _waypoints.get_next_point_position()
	var distance_to_target: float = owner.position.distance_to(target_position)
	if target_position.x < owner.position.x:
		owner.flip(-1)
	elif target_position.x > owner.position.x:
		owner.flip(1)

	_tween.interpolate_property(
		owner,
		"position",
		owner.position,
		target_position,
		distance_to_target / speed,
		Tween.EASE_IN,
		Tween.EASE_IN
	)
	_tween.start()


func _on_Tween_all_completed() -> void:
	_timer.start()


func _on_Player_entered(player: Player) -> void:
	owner.target = player
	_state_machine.transition_to("Alert")
