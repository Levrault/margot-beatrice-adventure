extends State


var next_state := ""
var next_msg := {}

onready var timer := $Timer


func enter(msg: Dictionary = {}) -> void:
	Events.connect("boss_state_changed_to", self, "_on_Boss_state_changed_to")
	timer.connect("timeout", self, "_on_Timeout")
	owner.hitbox.is_active = false
	owner.damage_source.is_active = true
	owner.skin.play("idle")


func exit() -> void:
	Events.disconnect("boss_state_changed_to", self, "_on_Boss_state_changed_to")
	timer.disconnect("timeout", self, "_on_Timeout")


func _on_Boss_state_changed_to(state: String, msg: Dictionary) -> void:
	if not owner.frustrum_culling.is_screen_visible:
		return
	next_state = state
	next_msg = msg
	timer.start()


func _on_Timeout() -> void:
	_state_machine.transition_to(next_state, next_msg)
