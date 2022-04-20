# Falling platform
# * When the player enter a first timer start
# * if the player is still on the platform, the off animation start
# * When the platform as exited the screen, we start the timer to make it respawn

extends KinematicBody2D

const FALLING_TIMER := 0.25

export var flying_offset := Vector2(0, 4)
export var delay := 0.0

var initial_position := Vector2.ZERO
var _is_falling := false
var _velocity := Vector2(0, 200)
var _has_player := false

onready var _tween := $Tween
onready var _player_detector := $PlayerDetector
onready var _anim := $AnimationPlayer
onready var _timer = $Timer
onready var _falling_timer = $FallingTimer
onready var _respawn_timer = $RespawnTimer


func _ready():
	_player_detector.connect("player_entered", self, "_on_Player_entered")
	_player_detector.connect("player_exited", self, "_on_Player_exited")
	_falling_timer.connect("timeout", self, "engine_falling")
	_respawn_timer.connect("timeout", self, "reset")
	_falling_timer.wait_time = FALLING_TIMER

	initial_position = position

	if delay > 0:
		_timer.connect("timeout", self, "floating_animation")
		_timer.wait_time = delay
		_timer.start()
		return

	floating_animation()


func _physics_process(delta):
	if not _is_falling:
		return

	position += _velocity * delta

	if position.y > SceneManager.bounds.limit_bottom:
		_is_falling = false
		visible = false
		_respawn_timer.start()


# Use by animation player on "respawn"
func floating_animation() -> void:
	_tween.interpolate_property(
		self,
		"position",
		position,
		Vector2(position.x, position.y + flying_offset.y),
		1,
		Tween.EASE_IN,
		Tween.TRANS_LINEAR
	)

	_tween.interpolate_property(
		self,
		"position",
		Vector2(position.x, position.y + flying_offset.y),
		position,
		1,
		Tween.EASE_IN,
		Tween.TRANS_LINEAR,
		1.0
	)
	_tween.start()


func engine_falling() -> void:
	_tween.stop_all()
	_anim.play("off")


func fall() -> void:
	_is_falling = true


func reset() -> void:
	_anim.play("respawn")
	visible = true
	position = initial_position


func _on_Player_entered(body: Player) -> void:
	if body == null:
		return
	body.is_snapped_to_floor = true

	_has_player = true
	_falling_timer.start()


func _on_Player_exited(body: Player) -> void:
	if body == null:
		return
	body.is_snapped_to_floor = false

	_has_player = false
	_falling_timer.stop()
	_falling_timer.wait_time = FALLING_TIMER
