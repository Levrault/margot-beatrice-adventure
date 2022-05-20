# Slow down time with an ease out effect to set 'momentum' when something
# great happen
extends Node2D
class_name Momentum

export (float) var DURATION := 0.07
export (float) var STRENGTH := 1.0

var is_active := false setget set_is_active
var time_start := 0.0
var duration_ms := 0.0
var start_value := 0.0


func _ready() -> void:
	set_process(false)


func set_is_active(value: bool) -> void:
	set_process(value)
	is_active = value


func start() -> void:
	self.is_active = true
	time_start = OS.get_ticks_msec()
	duration_ms = DURATION * 1000

	start_value = Config.values.accessibility.time_scale - STRENGTH
	if (start_value < 0):
		start_value = 0

	Engine.time_scale = start_value


# @param {float} delta
func _process(delta: float) -> void:
	var current_time: float = OS.get_ticks_msec() - time_start
	var value: float = circl_ease_in(current_time, start_value, Config.values.accessibility.time_scale, duration_ms)
	if current_time >= duration_ms:
		self.is_active = false
		value = Config.values.accessibility.time_scale
	Engine.time_scale = value


# ease in effect
# @param {float} time
# @param {float} start
# @param {float} end
# @param {float} duration
func circl_ease_in(time: float, start: float, end: float, duration: float) -> float:
	time /= duration
	return -end * (sqrt(1 - time * time) - 1) + start
