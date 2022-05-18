tool
extends Control

const TRANSITION_SPEED := .3

export var locked := true setget _set_locked
export var level_title := ""
export (Texture) var preview_texture = null
export var max_gems := 0
export var max_acorns := 0
export var max_carrots := 0
export var rank_s_time := 0.0
export var rank_a_time := 0.0
export var rank_b_time := 0.0

var data := {}
var level_path := ""

onready var tween := $Tween
onready var overlay := $Overlay
onready var load_level_button := $LoadLevelButton
onready var lock := $Lock


func _ready() -> void:
	yield(owner, "ready")
	owner.connect("navigation_finished", self, "_on_Navigation_finished")

	level_path = "res://src/Levels/%s.tscn" % get_name()
	load_level_button.connect("pressed", self, "_on_Load_level_button_pressed")

	load_level_button.disabled = locked
	load_level_button.focus_mode = Control.FOCUS_NONE
	if locked:
		lock.show()
	else:
		load_level_button.focus_mode = Control.FOCUS_ALL
		lock.hide()


func _set_locked(value: bool) -> void:
	locked = value

	if load_level_button:
		load_level_button.disabled = locked
		lock.visible = locked

		if not locked:
			load_level_button.focus_mode = Control.FOCUS_ALL


func _on_Focus_entered() -> void:
	tween.interpolate_property(
		overlay,
		"modulate:a",
		overlay.modulate.a,
		0,
		TRANSITION_SPEED,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	tween.start()
	Events.emit_signal("worldmap_preview_changed", preview_texture)
	Events.emit_signal("worldmap_best_time_changed", data.best_time)
	Events.emit_signal("worldmap_rank_changed", data.rank)
	Events.emit_signal("worldmap_level_name_changed", level_title)
	Events.emit_signal("worldmap_gems_percentage_changed", data.gems, max_gems)
	Events.emit_signal("worldmap_acorns_percentage_changed", data.acorns, max_acorns)
	Events.emit_signal("worldmap_carrots_percentage_changed", data.carrots, max_carrots)
	Events.emit_signal("worldmap_rank_s_time_changed", rank_s_time)
	Events.emit_signal("worldmap_rank_a_time_changed", rank_a_time)
	Events.emit_signal("worldmap_rank_b_time_changed", rank_b_time)


func _on_Focus_exited() -> void:
	tween.interpolate_property(
		overlay,
		"modulate:a",
		overlay.modulate.a,
		1,
		TRANSITION_SPEED,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	tween.start()


func _on_Navigation_finished() -> void:
	data = Serialize.profiles[Game.current_profile].levels[get_name()]
	self.locked = data.locked

	if load_level_button.has_focus():
		_on_Focus_entered()

	if not load_level_button.is_connected("focus_entered", self, "_on_Focus_entered"):
		load_level_button.connect("focus_entered", self, "_on_Focus_entered")

	if not load_level_button.is_connected("focus_exited", self, "_on_Focus_exited"):
		load_level_button.connect("focus_exited", self, "_on_Focus_exited")

	Events.emit_signal("worldmap_preview_animation_activated")


func _on_Load_level_button_pressed() -> void:
	Events.emit_signal("loading_transition_started", level_path)
