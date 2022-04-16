extends Area2D
class_name Hitbox

export (String) var collider_name := "CollisionShape2D" setget set_collider_name
onready var collider: CollisionShape2D = get_node_or_null(collider_name)

var is_active := true setget set_is_active


func _ready() -> void:
	if collider == null:
		queue_free()
	connect("area_entered", self, "_on_Area_entered")


func set_is_active(value: bool) -> void:
	is_active = value
	collider.set_deferred("disabled", not value)


func set_collider_name(node_name: String) -> void:
	if has_node(collider_name):
		get_node(collider_name).disabled = true
	if has_node(node_name):
		get_node(node_name).disabled = false

	print_debug("player hitbox %s changed to %s" % [collider_name, node_name])
	collider_name = node_name


func _on_Area_entered(damage_source: Area2D) -> void:
	var direction = 1
	if damage_source.global_position.x > global_position.x:
		direction = -1
	owner.hit_direction = direction
	if not owner.stats.invulnerable or damage_source.is_instakill:
		owner.take_damage(Hit.new(damage_source))
