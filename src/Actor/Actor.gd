# Should be seen has an abstract class
# Every character that can fight should inherit from it
class_name Actor
extends KinematicBody2D

export (int, -1, 1) var look_direction := 1

var skin: Node2D = null
var is_snapped_to_floor := false
var stop_on_slope := true

var hit_direction := 1.0

onready var stats: Stats = $Stats as Stats


# Actor has taken a hit
# @param {Hit} source
func take_damage(source: Hit) -> void:
	stats.take_damage(source)
