extends Area2D
class_name Hitbox

onready var collider: CollisionShape2D = $CollisionShape2D

var is_active := true setget set_is_active


func _ready() -> void:
	connect("area_entered", self, "_on_Area_entered")


func set_is_active(value: bool) -> void:
	is_active = value
	collider.set_deferred("disabled", not value)


func _on_Area_entered(damage_source: Area2D) -> void:
	var direction = 1
	if damage_source.global_position.x > global_position.x:
		direction = -1
	owner.hit_direction = direction
	if not owner.stats.invulnerable:
		owner.take_damage(Hit.new(damage_source))
