extends TextureRect

signal animation_finished

const SPEED_MULTIPLAYER := 8

export var playback_speed := 1.0
export var auto_start := true
export var auto_queue_free := true
export (String, "shot_in", "shot_out") var type = "shot_out"

var _animation_played := false
var _player_previous_position = null
var _log_displayed := false

onready var anim = $AnimationPlayer
onready var ring := $Ring


func _ready():
	yield(owner, "ready")

	if Project.get_setting("skip_irish_shot"):
		hide()
		return

	anim.connect("animation_finished", self, "_on_Animation_finished")
	anim.playback_speed = playback_speed

	if auto_start:
		play()


func play() -> void:
	if Project.get_setting("skip_irish_shot"):
		hide()
		return
	show()
	_animation_played = false
	Events.connect("player_moved", self, "_on_Player_moved")


func _on_Player_moved(player: Player) -> void:
	if not _animation_played:
		anim.play(type)
		_animation_played = true

	var target = player.get_global_transform_with_canvas().origin
	target.x = clamp(target.x, 0, get_viewport_rect().size.x) / get_viewport_rect().size.x
	target.y = clamp(target.y, 0, get_viewport_rect().size.y) / get_viewport_rect().size.y

	# if player move, playback_speed is multiplayed to display the env asap
	if player.is_handling_input:
		if _player_previous_position == null:
			_player_previous_position = target
		elif not target.is_equal_approx(_player_previous_position):
			anim.playback_speed = playback_speed * SPEED_MULTIPLAYER
			if not _log_displayed:
				print_debug("Irisshot animation speed has been multiplayed")
				_log_displayed = true

	get_material().set_shader_param("target", target)
	ring.get_material().set_shader_param("target", target)


func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "DEFAULT":
		return
	if auto_queue_free:
		queue_free()
	emit_signal("animation_finished")
