# Singleton that manage level
extends Node

var loading_screen_scene: Resource = preload("res://src/UI/LoadingScreen.tscn")
var loading_screen: Node

var loader: ResourceInteractiveLoader
var scene_path := ""
var wait_frames: int = 1
var time_max: int = 100  # msec
var current_scene = null
var root: Node


func _ready() -> void:
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


# Catch when a level can't be found
func show_error() -> void:
	print("Scene was not loaded")


# load new scene
# @param {String} path
func goto_scene(path):  # Game requests to switch to this scene.
	loader = ResourceLoader.load_interactive(path)
	if loader == null:  # Check for errors.
		show_error()
		return
	set_process(true)

	current_scene.queue_free()  # Get rid of the old scene.
	loading_screen = loading_screen_scene.instance()
	root.add_child(loading_screen)

	wait_frames = 1


# compute loading process
# @param {float} time
func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF:  # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			break
		else:  # Error during loading.
			show_error()
			loader = null
			break


# load new scene
# @param {Resource} scene_resource
func set_new_scene(scene_resource):
	loading_screen.queue_free()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
