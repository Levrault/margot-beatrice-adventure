extends State

export var x_speed := 400.0
export var y_speed := 250.0
export var ghost_delay := 0.15

var ghost_scene = preload("res://src/Player/Fox/GhostFox.tscn")
var ghost_particule_scene = preload("res://src/Player/Fox/GhostParticule.tscn")

var _ghost = null
var _speed := 0.0
var _direction := Vector2.ZERO
var _velocity := Vector2.ZERO
var _is_anticipation_over := false
var _is_input_registred := false

onready var _timer = $Timer
onready var _timer_ghost := $TimerGhost
onready var _cooldown := $Cooldown
onready var _tween := $Tween
onready var _sfx := $Woosh

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)


func physics_process(delta: float) -> void:
	if not _is_anticipation_over:
		return

	if not _is_input_registred:
		_is_input_registred = true
		_direction = get_move_direction()
		owner.flip(_direction.x)
		# if not input were touch in the enter param, try to get them again
		if _direction == Vector2.ZERO:
			_direction.x = owner.look_direction
		_speed = y_speed if _direction.y != 0 else x_speed

	_velocity = owner.move_and_slide(_direction * _speed, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)


func enter(msg: Dictionary = {}) -> void:
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished")
	owner.skin.play("dash_anticipation")
	var particule = ghost_particule_scene.instance()
	owner.get_parent().add_child(particule)
	particule.position = owner.position
	particule.scale = owner.skin.scale
	_sfx.play_sound()
	
	if InputManager.is_using_gamepad():
		Input.start_joy_vibration(0, Config.values.gamepad_layout.gamepad_vibration, 0, .200)


func exit() -> void:
	owner.set_collision_mask_bit(Layer.PASS_TROUGHT_LAYER, true)
	
	if _timer_ghost.is_connected("timeout", self, "_on_Ghost_timeout"):
		_timer_ghost.disconnect("timeout", self, "_on_Ghost_timeout")
	_speed = 0.0
	_direction = Vector2.ZERO
	_velocity = Vector2.ZERO
	_is_anticipation_over = false
	_is_input_registred = false


func _on_Skin_animation_finished(anim_name: String) -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")

	_is_anticipation_over = true
	owner.set_collision_mask_bit(Layer.PASS_TROUGHT_LAYER, false)

	if _cooldown.is_connected("timeout", self, "_on_Cooldown_timeout"):
		_cooldown.disconnect("timeout", self, "_on_Cooldown_timeout")

	_timer.connect("timeout", self, "_on_Dash_timeout", [], CONNECT_ONESHOT)
	_timer.start()

	_timer_ghost.connect("timeout", self, "_on_Ghost_timeout")
	_timer_ghost.start()

	owner.skin.play("dash")


func _on_Dash_timeout() -> void:
	_state_machine.transition_to("Move/Air", {velocity = _velocity / 2})
	_timer_ghost.stop()
	_cooldown.connect("timeout", self, "_on_Cooldown_timeout", [], CONNECT_ONESHOT)
	_cooldown.start()


func _on_Ghost_timeout() -> void:
	_ghost = ghost_scene.instance()
	owner.get_parent().add_child(_ghost)
	_ghost.position = owner.position
	_ghost.scale = owner.skin.scale
	_tween.interpolate_property(
		_ghost,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		ghost_delay,
		Tween.EASE_IN,
		Tween.EASE_OUT
	)
	_tween.start()
	if not _tween.is_connected("tween_all_completed", self, "_on_Tween_completed"):
		_tween.connect("tween_all_completed", self, "_on_Tween_completed")


func _on_Tween_completed() -> void:
	_ghost.queue_free()


func _on_Cooldown_timeout() -> void:
	_parent.dash_count = 0
