extends Node2D

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
	"boss"
) var next_level

onready var player: Player = find_node("Player")
onready var _anchors := $Anchors.get_children()
onready var iris_shot := $FullScreenShader/IrisShot


func _ready() -> void:
	if not ProjectSettings.get_setting("game/debug"):
		set_process_unhandled_input(false)

	Game.current_level = get_name()

	# start cinematic
	var introduction_cinematic = get_node_or_null(introduction_cinematic_path)
	if ProjectSettings.get_setting("game/skip_cinematic"):
		introduction_cinematic.queue_free()
		introduction_cinematic = null
	if introduction_cinematic != null:
		iris_shot.hide()
		Events.connect("cinematic_intro_ended", self, "initialize")
		introduction_cinematic.initialize()
		return
	initialize()


func _exit_tree() -> void:
	SceneManager.anchor = null
	Game.current_level = ""


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

	if event.is_action_pressed("debug_pause"):
		if Engine.time_scale == 0.0:
			Engine.time_scale = 1.0
		else:
			Engine.time_scale = 0.0
		return

	if event.is_action_pressed("debug_slow_time"):
		if Engine.time_scale == 0.1:
			Engine.time_scale = 1.0
		else:
			Engine.time_scale = 0.1
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
	iris_shot.show()
	iris_shot.play()
	# Camera management
	SceneManager.anchor = get_nearest_anchor()
	SceneManager.anchor.update_anchor_limit()
	SceneManager.is_anchor_locked = false

	# track player
	Events.connect("player_moved", self, "_on_Player_moved")
	Events.connect("player_moved", self, "_on_Level_started")
	iris_shot.connect("animation_finished", self, "_on_Level_started")
	Events.emit_signal("room_loaded")
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


func _on_Level_started(player: Player) -> void:
	Events.emit_signal("level_started")
	iris_shot.disconnect("animation_finished", self, "_on_Level_started")
	Events.disconnect("player_moved", self, "_on_Level_started")
