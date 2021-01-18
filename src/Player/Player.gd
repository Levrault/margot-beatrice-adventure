# Main controlled character
tool
class_name Player
extends Actor

const PASS_TROUGHT_LAYER := 2

const FLOOR_NORMAL := Vector2.UP
const SNAP := Vector2(0, 10)
const Collection: Script = preload("res://src/Utils/Collection.gd")

var is_active := true setget set_is_active
var is_handling_input := true setget set_is_handling_input
var abilities := {"dash": false, "double_jump": false}
var skin: Node2D = null
var initial_state_data := {}
var look_direction := 1.0

onready var pass_through: Area2D = $PassThrough
onready var state_machine: StateMachine = $StateMachine
onready var camera_rig: Position2D = $CameraRig
onready var camera: Camera2D = $CameraRig/Camera
onready var collider: CollisionShape2D = $CollisionShape2D
onready var hitbox: Hitbox = $Hitbox as Hitbox
onready var momentum: Momentum = $Momentum as Momentum
onready var character_factory := $CharacterFactory
onready var attack_factory := $AttackFactory
onready var npc_interaction := $NpcInteraction
onready var life = $HUD.life_progress
onready var effects := $Effects


func _ready() -> void:
	Events.connect("player_room_entered", self, "_on_Player_Room_entered")
	Events.connect("camera_anchor_changed", self, "_on_Camera_anchor_changed")
	stats.connect("health_depleted", self, "_on_Stats_health_depleated")
	stats.connect("health_changed", life, "_on_Health_changed")
	abilities = Collection.merge(abilities, Game.unlocked_abilities)
	life.max_value = stats.max_health
	life.value = stats.max_health


func set_is_handling_input(value: bool) -> void:
	$StateMachine.set_process_unhandled_input(value)
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
		effects.damage_effect()
		return

	state_machine.transition_to("Die")


func horizontal_mirror(direction: float) -> void:
	if direction == 0:
		return
	look_direction = sign(direction)
	skin.scale.x = look_direction


# Unlock acces to new state machine state
# @param {String} ability_name
func unlock_ability(ability_name: String) -> void:
	if abilities.has(ability_name):
		abilities[ability_name] = true
		print_debug("unlock %s abilities" % [ability_name])


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


func _on_Stats_health_depleated() -> void:
	state_machine.transition_to("Die")


func _on_Camera_anchor_changed() -> void:
	owner.set_process(false)
	self.is_handling_input = false
	get_tree().paused = true
	camera_rig.transit_to_new_room()
