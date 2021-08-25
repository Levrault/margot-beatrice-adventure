extends Actor
class_name Enemy

onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	stats.connect("health_depleted", self, "_on_Stats_health_depleated")
	skin = get_node_or_null("Skin")
	assert(skin != null)


func _on_Stats_health_depleated():
	state_machine.transition_to("Die")
