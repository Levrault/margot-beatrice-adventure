extends Node2D

export (bool) var full_screen_shader := true

onready var player: Player = find_node("Player")
onready var _anchors := $Anchors.get_children()


func _ready() -> void:
	if not full_screen_shader:
		$FullScreenShader.queue_free()

	# Camera management
	SceneManager.anchor = get_nearest_anchor()
	SceneManager.anchor.update_anchor_limit()

	if SceneManager.path.empty():
		print_debug("SceneManager.path is not set, %s was set instead" % [filename])
		SceneManager.path = filename

	# track player
	Events.connect("player_moved", self, "_on_Player_moved")
	Events.emit_signal("room_loaded")
	Events.emit_signal("level_started")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart_level"):
		print_debug("--Level Restarted by debug command--")
		AsyncLoading.goto_scene(filename)
		return

	if event.is_action_pressed("debug_spawn"):
		player.state_machine.transition_to("Spawn")
		return

	if event.is_action_pressed("debug_die"):
		player.state_machine.transition_to("Die")
		return

	if event.is_action_pressed("debug_slow_time"):
		Engine.time_scale = .1
		return

	if event.is_action_pressed("debug_accelerate_time"):
		Engine.time_scale = Engine.time_scale + .05
		return

	if event.is_action_pressed("debug_reset_time"):
		Engine.time_scale = 1.0
		return

	if event.is_action_pressed("debug_free_camera"):
		player.is_handling_input = not player.is_handling_input
		if not player.is_handling_input:
			var free_camera: Camera2D = load("res://src/Tools/FreeCamera.tscn").instance()
			free_camera.position = player.position
			add_child(free_camera)
		else:
			get_node("FreeCamera").queue_free()


func get_nearest_anchor() -> Position2D:
	var nearest_anchor = _anchors[0]

	for anchor in _anchors:
		# viewport sized room
		if (
			anchor.position.distance_to(player.position)
			< nearest_anchor.position.distance_to(player.position)
		):
			nearest_anchor = anchor

	return nearest_anchor


func _on_Player_moved(player: Player) -> void:
	if SceneManager.is_anchor_locked:
		return

	var nearest_anchor = get_nearest_anchor()

	if SceneManager.anchor == nearest_anchor:
		return

	print_debug(
		(
			"%s camera's anchor has been changed to %s"
			% [SceneManager.anchor.name, nearest_anchor.name]
		)
	)

	SceneManager.anchor = nearest_anchor
	Events.emit_signal("camera_anchor_changed")
