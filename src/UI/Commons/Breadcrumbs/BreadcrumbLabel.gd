# Label that represent a breabcrumbs element
# @category: Breadcrumbs
extends Label

var active := false setget set_active
var translation_key := ""

onready var anim := $AnimationPlayer


func _ready() -> void:
	if active:
		anim.play("active")
	else:
		anim.play("inactive")


func set_active(value: bool) -> void:
	active = value
	if active:
		anim.play("active")
	else:
		anim.play("inactive")
