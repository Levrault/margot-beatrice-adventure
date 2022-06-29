extends Control

export var image_size := Vector2(160, 90)
export var export_path :=  "res://assets/UI/worldmap/%s-%s.png"

var should_disable_player_hud := true

onready var anim := $AnimationPlayer


func _ready() -> void:
	if not Project.get_setting("screenshot"):
		queue_free()

	Events.connect("player_hud_enabled", self, "set", ["should_disable_player_hud", true])
	Events.connect("player_hud_disabled", self, "set", ["should_disable_player_hud", false])


# @param {InputEvent} event
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_screenshot"):
		Events.emit_signal("screenshot_started")

		if should_disable_player_hud:
			Events.emit_signal("player_hud_disabled")

		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		call_deferred("screenshot")


func screenshot() -> void:
	# get data
	var img = get_viewport().get_texture().get_data()
	# wait two frames
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# flip
	img.flip_y()

	img.resize(image_size.x, image_size.y, 0)

	# save to file
	img.save_png(
		"%s/%s-%s.png" % [export_path, owner.get_name(), String(OS.get_unix_time())]
	)

	anim.play("TransitionIn")

	Events.call_deferred("emit_signal", "screenshot_ended")

	if should_disable_player_hud:
		Events.call_deferred("emit_signal", "player_hud_enabled")
