extends State

export var speed := 500.0

var _direction := Vector2.ZERO
var _velocity := Vector2.ZERO

onready var timer = $Timer
onready var cooldown = $Cooldown

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 0
	)


func physics_process(delta: float) -> void:
	_velocity = owner.move_and_slide(_direction * speed, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)


func enter(msg: Dictionary = {}) -> void:
	_direction = get_move_direction()
	if _direction == Vector2.ZERO:
		_direction.x = owner.look_direction

	if cooldown.is_connected("timeout", self, "_on_Cooldown_timeout"):
		cooldown.disconnect("timeout", self, "_on_Cooldown_timeout")

	timer.connect("timeout", self, "_on_Dash_timeout", [], CONNECT_ONESHOT)
	timer.start()
	owner.skin.play("dash")


func _on_Dash_timeout() -> void:
	_state_machine.transition_to("Move/Air", {velocity = _velocity / 2})
	cooldown.connect("timeout", self, "_on_Cooldown_timeout", [], CONNECT_ONESHOT)
	cooldown.start()


func _on_Cooldown_timeout() -> void:
	_parent.dash_count = 0
