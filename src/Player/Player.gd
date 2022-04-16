# Main controlled character
tool
class_name Player
extends Actor

const FLOOR_NORMAL := Vector2.UP
const SNAP := Vector2(0, 20)
const Collection: Script = preload("res://src/Utils/Collection.gd")

var is_active := true setget set_is_active
var is_handling_input := true setget set_is_handling_input
var is_on_moving_platform := false
var initial_state_data := {}
var life := 3
var spawn_position := position

onready var pass_through: Area2D = $PassThrough
onready var moving_platform_detector: Area2D = $MovingPlatformDetector
onready var state_machine: StateMachine = $StateMachine
onready var camera_rig: Position2D = $CameraRig
onready var camera: Camera2D = $CameraRig/Camera
onready var collider: CollisionShape2D = $FoxCollisionShape
onready var hitbox: Hitbox = $Hitbox as Hitbox
onready var momentum: Momentum = $Momentum as Momentum
onready var character_factory := $CharacterFactory
onready var attack_factory := $AttackFactory
onready var npc_interaction := $NpcInteraction
onready var life_bar = $HUD.life_progress


func _ready() -> void:
	Events.connect("player_room_entered", self, "_on_Player_Room_entered")
	Events.connect("camera_anchor_changed", self, "_on_Camera_anchor_changed")
	Events.connect("player_character_changed", self, "_on_Player_character_changed")
	Events.connect("player_input_disabled", self, "set_is_handling_input", [false])
	Events.connect("player_input_enabled", self, "set_is_handling_input", [true])
	moving_platform_detector.connect("body_entered", self, "_on_Moving_platform_entered")
	moving_platform_detector.connect("body_exited", self, "_on_Moving_platform_exited")
	stats.connect("health_depleted", self, "_on_Stats_health_depleated")
	stats.connect("health_changed", life_bar, "_on_Health_changed")

	life_bar.max_value = stats.max_health
	life_bar.value = stats.max_health


func set_is_handling_input(value: bool) -> void:
	state_machine.set_process_unhandled_input(value)
	is_handling_input = value


func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.set_deferred("disabled", not value)


func take_damage(source: Hit) -> void:
	.take_damage(source)
	if stats.health > 0 and not source.is_instakill:
		state_machine.transition_to("Move/Hurt", {impulse = true})
		character_factory.effects.damage_effect()
		return

	state_machine.transition_to("Die")


func flip(direction: float) -> void:
	if direction == 0:
		return
	# warning-ignore:narrowing_conversion
	look_direction = sign(direction)
	skin.scale.x = look_direction


func change_state_data(character_data: Dictionary) -> void:
	for key in initial_state_data:
		var state := state_machine.get_node(key)
		for data in initial_state_data[key]:
			state[data] = initial_state_data[key][data]
	for key in character_data:
		var state := state_machine.get_node(key)
		if not initial_state_data.has(key):
			initial_state_data[key] = {}
		for data in character_data[key]:
			initial_state_data[key][data] = state[data]
			state[data] = character_data[key][data]


func _on_Player_Room_entered(global_position: Vector2) -> void:
	self.global_position = global_position


func _on_Player_character_changed() -> void:
	collider.disabled = true
	print_debug(
		(
			"player collision %s changed to %s"
			% [collider.name, Character.hitboxes[Character.selected]]
		)
	)
	collider = get_node(Character.hitboxes[Character.selected])
	collider.disabled = false


func _on_Stats_health_depleated() -> void:
	state_machine.transition_to("Die")


func _on_Camera_anchor_changed() -> void:
	owner.set_process(false)
	self.is_handling_input = false
	get_tree().paused = true
	camera_rig.transit_to_new_room()


func _on_Moving_platform_entered(body: Area2D) -> void:
	is_on_moving_platform = true


func _on_Moving_platform_exited(body: Area2D) -> void:
	is_on_moving_platform = false
