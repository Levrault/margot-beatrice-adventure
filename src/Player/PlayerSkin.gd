extends ActorSkin
class_name PlayerSkin

signal shader_finished(anim_name)

onready var shader_anim = $ShaderAnim


func _ready() -> void:
	shader_anim.connect("animation_finished", self, "_on_Shader_animation_finished")


func execute_shader(shader_name: String) -> void:
	assert(shader_name in shader_anim.get_animation_list())
	shader_anim.play(shader_name)


func _on_Shader_animation_finished(anim_name: String) -> void:
	emit_signal("shader_finished", anim_name)
