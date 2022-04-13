extends Node2D
class_name FrustumCulling

var is_screen_visible = false
var initial_position := Vector2.ZERO


func _ready() -> void:
	yield(owner, "ready")
	Events.connect("room_limit_changed", self, "_on_Room_limit_changed")
	Events.connect("room_transition_started", self, "_on_Room_transition_started")
	Events.connect("room_transition_ended", self, "_on_Room_transition_ended")
	initial_position = owner.position


func is_on_screen(bounds: Dictionary) -> bool:
	if owner.global_position.y > bounds.limit_bottom:
		return false
	if owner.global_position.y < bounds.limit_top:
		return false
	if owner.global_position.x < bounds.limit_left:
		return false
	if owner.global_position.x > bounds.limit_right:
		return false
	return true


func _on_Room_transition_started() -> void:
	owner.set_deferred("position", initial_position)


func _on_Room_transition_ended() -> void:
	pass


func _on_Room_limit_changed(bounds: Dictionary) -> void:
	is_screen_visible = is_on_screen(bounds)
	owner.call_deferred("set_physics_process", is_screen_visible)
	owner.call_deferred("set_process", is_screen_visible)
