class_name AttackFactory, "res://assets/icons/attack_factory.svg"
extends Node2D

var is_attacking := false

onready var damage_source: DamageSource = $DamageSource as DamageSource


func _ready() -> void:
	yield(owner, "ready")


func create() -> void:
	if is_attacking:
		return
	is_attacking = true
	damage_source.set_active(true)


func destroy() -> void:
	is_attacking = false
	damage_source.set_active(false)
