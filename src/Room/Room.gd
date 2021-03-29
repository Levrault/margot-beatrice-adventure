extends Node2D

export (bool) var full_screen_shader := true

onready var player: Player = find_node("Player")
onready var _anchors := $Anchors.get_children()


func _ready() -> void:
	if not full_screen_shader:
		$FullScreenShader.queue_free()

	# Camera management
	RoomManager.anchor = get_nearest_anchor()
	RoomManager.anchor.update_anchor_limit()

	# track player
	Events.connect("player_moved", self, "_on_Player_moved")
	Events.emit_signal("room_transition_ended")
	Events.emit_signal("room_loaded")
	count_collectable()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart_level"):
		get_tree().reload_current_scene()
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


func count_collectable() -> void:
	var gems := 0
	var acorns := 0
	var carrots := 0
	for collectable in $Collectables.get_children():
		if collectable.character == Character.Playable.FOX:
			gems += 1
			continue
		if collectable.character == Character.Playable.SQUIRREL:
			acorns += 1
			continue
		if collectable.character == Character.Playable.RABBIT:
			carrots += 1
			continue
	Events.emit_signal("collectable_max_value_counted", gems, acorns, carrots)


func get_nearest_anchor() -> Position2D:
	var non_sized_anchors := []
	var sized_anchors := []

	for anchor in _anchors:
		if not anchor.is_viewport_sized():
			non_sized_anchors.append(anchor)
			continue
		sized_anchors.append(anchor)

	var nearest_anchor = _anchors[0]
	var nearest_entrance = null

	if not non_sized_anchors.empty():
		nearest_entrance = non_sized_anchors[0].get_nearest_entrance(player.position)

	for anchor in sized_anchors:
		# viewport sized room
		if (
			anchor.position.distance_to(player.position)
			< nearest_anchor.position.distance_to(player.position)
		):
			nearest_anchor = anchor

	# compare nearest to non screen sized room
	for anchor in non_sized_anchors:
		# bigger anchor, find nearest entrance
		var entrance = anchor.get_nearest_entrance(player.position)

		if not entrance:
			continue

		# if too far skip
		if (
			entrance.global_position.distance_to(player.global_position)
			> nearest_anchor.position.distance_to(player.position)
		):
			continue

		# entrance can be the nearest
		if (
			entrance.global_position.distance_to(player.global_position)
			<= nearest_entrance.global_position.distance_to(player.global_position)
		):
			nearest_anchor = anchor
			nearest_entrance = entrance

	return nearest_anchor


func _on_Player_moved(player: Player) -> void:
	if RoomManager.is_anchor_locked:
		return

	var nearest_anchor = get_nearest_anchor()

	if RoomManager.anchor == nearest_anchor:
		return

	print_debug(
		"%s camera's anchor has been changed to %s" % [RoomManager.anchor.name, nearest_anchor.name]
	)

	RoomManager.anchor = nearest_anchor
	Events.emit_signal("camera_anchor_changed")
