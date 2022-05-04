extends StaticBody2D


var active := false setget set_active


onready var explosion_air := $ExplosionAir
onready var collision_shape := $CollisionShape2D
onready var sprite := $Sprite


func _ready() -> void:
	collision_shape.disabled = not active
	sprite.visible = active


func set_active(value: bool) -> void:
	active = value
	collision_shape.set_deferred("disabled", not value)
	sprite.visible = active
	explosion_air.start()
