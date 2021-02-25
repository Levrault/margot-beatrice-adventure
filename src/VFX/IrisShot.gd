extends TextureRect


onready var anim = $AnimationPlayer
onready var ring := $Ring


func _ready():
	yield(owner, "ready")
	Events.connect("player_moved", self, "_on_Player_moved")
	show()


func _on_Player_moved(player: Player) -> void:
	anim.play("play")
	var target = player.get_global_transform_with_canvas().origin
	target.x = clamp(target.x, 0, get_viewport_rect().size.x) / get_viewport_rect().size.x
	target.y = clamp(target.y, 0, get_viewport_rect().size.y) / get_viewport_rect().size.y
	get_material().set_shader_param("target", target)
	ring.get_material().set_shader_param("target", target)
