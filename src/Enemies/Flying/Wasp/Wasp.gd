extends Enemy

var target: Player = null

onready var player_detector := $PlayerDetector


func _ready() -> void:
	player_detector.get_node("CollisionShape2D").disabled = true


func _on_Room_transition_started() -> void:
	skin.anim.stop()

	# fix position issue if wasp is in follow mode
	if state_machine.state_name != "Follow":
		set_deferred("position", initial_position)


func _on_Room_limit_changed(bounds: Dictionary) -> void:
	._on_Room_limit_changed(bounds)
	player_detector.disabled = not is_screen_visible

	if state_machine.state_name == "Follow":
		set_deferred("position", initial_position)
