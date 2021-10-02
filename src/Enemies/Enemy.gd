extends Actor
class_name Enemy

var is_screen_visible := false

onready var state_machine: StateMachine = $StateMachine
onready var damage_source: DamageSource = $DamageSource
onready var hitbox: Hitbox = $Hitbox
onready var initial_position := position
onready var initial_look_direction: int = look_direction


func _ready() -> void:
	Events.connect("room_limit_changed", self, "_on_Room_limit_changed")
	Events.connect("room_transition_started", self, "_on_Room_transition_started")
	Events.connect("room_transition_ended", self, "_on_Room_transition_ended")
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


func _on_Room_transition_started() -> void:
	skin.anim.stop()
	set_deferred("position", initial_position)


func _on_Room_transition_ended() -> void:
	state_machine.call_deferred("reset")
	call_deferred("flip", initial_look_direction)
	if not is_screen_visible:
		skin.anim.call_deferred("stop")


func _on_Room_limit_changed(bounds: Dictionary) -> void:
	is_screen_visible = is_on_screen(bounds)
	call_deferred("set_physics_process", is_screen_visible)
	call_deferred("set_process", is_screen_visible)
	state_machine.call_deferred("set_physics_process", is_screen_visible)
	state_machine.call_deferred("set_process", is_screen_visible)
