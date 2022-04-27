# Manage checkpoint
extends Node2D
class_name Checkpoint

var player_position := Vector2.ZERO

onready var spawn_position := $Position2D


func _ready():
	Events.connect("room_transition_ended", self, "_on_Room_transition_ended")
	Events.connect("player_moved", self, "_on_Player_moved")

	if not Project.get_setting("spawn"):
		spawn_position.get_node("Control/Label").hide()
		return


func is_on_screen(bounds: Dictionary) -> bool:
	if spawn_position.global_position.y > bounds.limit_bottom:
		return false
	if spawn_position.global_position.y < bounds.limit_top:
		return false
	if spawn_position.global_position.x < bounds.limit_left:
		return false
	if spawn_position.global_position.x > bounds.limit_right:
		return false
	return true


func _on_Room_transition_ended() -> void:
	var is_screen_visible = SceneManager.is_on_screen(global_position)
	spawn_position.get_node("Control/Label").text = String(is_screen_visible)

	if is_screen_visible:
		Events.emit_signal("spawn_position_changed", spawn_position)


func _on_Player_moved(player: Player) -> void:
	player_position = player.global_position
