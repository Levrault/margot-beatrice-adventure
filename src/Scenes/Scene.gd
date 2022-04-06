extends Node2D

export var full_screen_shader := true
export var introduction_cinematic_path = NodePath()
export var music_track := "lyonesse"
export (
	String,
	"level1",
	"level2",
	"level3",
	"level4",
	"level5",
	"level6",
	"level7",
	"level8",
	"level9",
	"level10",
	"level11",
	"level12",
	"level13",
	"level14",
	"level15",
	"level16",
	"level17",
	"level18",
	"level19",
	"level20"
) var next_level

onready var player: Player = find_node("Player")
onready var _anchors := $Anchors.get_children()


func _ready() -> void:
	# start cinematic
	var introduction_cinematic = get_node_or_null(introduction_cinematic_path)
	if introduction_cinematic != null:
		Events.connect("cinematic_intro_ended", self, "initialize")
		introduction_cinematic.initialize()
		return
	initialize()


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


func initialize() -> void:
	if not full_screen_shader:
		$FullScreenShader.queue_free()
	else:
		$FullScreenShader/IrisShot.play()
	# Camera management
	SceneManager.anchor = get_nearest_anchor()
	SceneManager.anchor.update_anchor_limit()

	# track player
	Events.connect("player_moved", self, "_on_Player_moved")
	Events.emit_signal("room_loaded")
	Events.emit_signal("level_started")

	MusicPlayer.change_track(music_track)


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
