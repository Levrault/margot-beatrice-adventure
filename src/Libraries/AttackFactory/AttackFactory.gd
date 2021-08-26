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
	damage_source.is_active = true
	owner.hitbox.set_collision_mask_bit(Layer.DAMAGE_SOURCE_ENEMY_LAYER, false)


func destroy() -> void:
	is_attacking = false
	damage_source.is_active = false
	owner.hitbox.set_collision_mask_bit(Layer.DAMAGE_SOURCE_ENEMY_LAYER, true)
