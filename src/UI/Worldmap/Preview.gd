extends TextureRect

var next_texture: Texture = null
var skip_animation := true

onready var anim := $AnimationPlayer


func _ready():
	owner.connect("navigation_finished", self, "_on_Navigation_finished")
	Events.connect("worldmap_preview_changed", self, "_on_Worldmap_preview_changed")
	Events.connect(
		"worldmap_preview_animation_activated", self, "_on_Worldmap_preview_animation_activated"
	)


func change_texture() -> void:
	texture = next_texture


func _on_Worldmap_preview_changed(new_texture: Texture) -> void:
	anim.stop()
	next_texture = new_texture
	if skip_animation:
		change_texture()
		return
	anim.play("fadeInOut")


func _on_Worldmap_preview_animation_activated() -> void:
	skip_animation = false


func _on_Navigation_finished() -> void:
	skip_animation = true
