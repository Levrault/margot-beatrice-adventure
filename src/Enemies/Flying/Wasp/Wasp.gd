extends Enemy

var target: Player = null

onready var player_detector := $PlayerDetector


func _ready() -> void:
	player_detector.get_node("CollisionShape2D").disabled = true


func _on_Room_limit_changed(bounds:Dictionary) -> void:
	._on_Room_limit_changed(bounds)
	player_detector.get_node("CollisionShape2D").disabled = not is_screen_visible
	if not is_screen_visible and get_parent() is Waypoints:
		get_parent().reset()

	if is_screen_visible:
		state_machine.transition_to(state_machine.get_node(state_machine.initial_state).get_name())
