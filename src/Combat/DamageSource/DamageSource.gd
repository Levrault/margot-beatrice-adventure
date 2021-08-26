# Represents a weapon or any entity that can damage others Currently
# barebones, but we can extend this class to add an element like fire, ice, etc.
# Or a status modifier like poison, the chances to apply a given status effect,
# and other metadata that we can later transform into an actual attack. See Hit.gd
class_name DamageSource
extends Area2D

export var damage := 1
export var is_instakill := false

var is_active := true setget set_active


func set_active(value: bool) -> void:
	is_active = value
	$CollisionShape2D.set_deferred("disabled", not value)
