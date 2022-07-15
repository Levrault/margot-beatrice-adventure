extends Actor
class_name Enemy

onready var state_machine: StateMachine = $StateMachine
onready var damage_source: DamageSource = $DamageSource
onready var hitbox: Hitbox = $Hitbox
onready var initial_position := position
onready var initial_look_direction: int = look_direction
onready var frustrum_culling := $FrustumCulling


func _ready() -> void:
	Events.connect("level_finished", self, "_on_Level_finished")
	stats.connect("health_depleted", self, "_on_Stats_health_depleated")
	skin = get_node_or_null("Skin")
	assert(skin != null)


func _on_Stats_health_depleated():
	state_machine.transition_to("Die")


func flip(direction: int = 0) -> void:
	if direction == 0:
		look_direction *= -1
		scale.x *= -1
		return

	if look_direction == direction:
		return

	look_direction = direction
	scale.x *= -1


func _on_Level_finished() -> void:
	queue_free()
