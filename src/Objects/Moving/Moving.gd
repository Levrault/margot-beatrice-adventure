extends KinematicBody2D

export var distance_before_freeing := 300
export var speed := 50
export var max_speed_default := Vector2(75.0, 0)
export var acceleration_default := Vector2(100, 0)
export var decceleration_default := Vector2(100, 0)
export var max_speed_fall := 0
export var max_dash_count := 1

var direction := 1
var acceleration := acceleration_default
var decceleration := decceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO


onready var tween := $Tween


func _ready() -> void:
	set_physics_process(false)


func spawn() -> void:
	tween.interpolate_property(
		self, "position", position, Vector2(position.x + 8, position.y), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		self, "position", Vector2(position.x + 8, position.y), position, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, .5
	)
	tween.start()


func launch() -> void:
	tween.stop_all()
	tween.connect("tween_all_completed", self, "_on_Tween_all_completed")
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	velocity = Move.calculate_velocity(
		velocity, max_speed, acceleration, decceleration, delta, Vector2(direction, 1.0)
	)
	velocity = move_and_slide(velocity)

	if position.x > distance_before_freeing and not tween.is_active():
		tween.interpolate_property(
			self, "modulate:a", self.modulate.a, 0.0, .9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		tween.start()


func _on_Tween_all_completed() -> void:
	queue_free()
