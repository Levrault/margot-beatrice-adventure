extends Actor
class_name Enemy

var is_screen_visible := false

onready var state_machine: StateMachine = $StateMachine
onready var damage_source: DamageSource = $DamageSource
onready var hitbox: Hitbox = $Hitbox
onready var initial_position := position


func _ready() -> void:
	Events.connect("room_limit_changed", self, "_on_Room_limit_changed")
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


func is_on_screen(bounds: Dictionary) -> bool:
	if global_position.y > bounds.limit_bottom:
		return false
	if global_position.y < bounds.limit_top:
		return false
	if global_position.x < bounds.limit_left:
		return false
	if global_position.x > bounds.limit_right:
		return false
	return true


func _on_Room_limit_changed(bounds:Dictionary) -> void:
	is_screen_visible = is_on_screen(bounds)
	set_physics_process(is_screen_visible)
	set_process(is_screen_visible)
	state_machine.set_physics_process(is_screen_visible)
	state_machine.set_process(is_screen_visible)

	if not is_screen_visible:
		position = initial_position
		state_machine.transition_to(state_machine.get_node(state_machine.initial_state).get_name())
