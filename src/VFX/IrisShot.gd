extends TextureRect

export var auto_start := true
export var auto_queue_free := true
export (String, "shot_in", "shot_out") var type = "shot_out"

var _animation_played := false

onready var anim = $AnimationPlayer
onready var ring := $Ring


func _ready():
	yield(owner, "ready")
	anim.connect("animation_finished", self, "_on_Animation_finished")

	if auto_start:
		play()


func play() -> void:
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
	get_material().set_shader_param("target", target)
	ring.get_material().set_shader_param("target", target)


func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "DEFAULT":
		return
	if auto_queue_free:
		queue_free()
