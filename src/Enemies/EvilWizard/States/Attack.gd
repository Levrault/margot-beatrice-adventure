extends State

const LASER_DELAY := 1.5
const MAGIC_DELAY := 2.0
const LASER_SCENE := preload("res://src/Objects/Moving/MovingLaser.tscn")
const MAGIC_SCENE := preload("res://src/Objects/Moving/TornadoLoop.tscn")

export var projectiles_spawn_default := 3

var projectiles_to_spawn := projectiles_spawn_default

onready var delay := $Delay
onready var laser_spawn_position := $LaserSpawnPosition
onready var magic_spawn_position := $MagicSpawnPosition
onready var sfx := $SFXPlayer


func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("idle")
	if "laser" in msg:
		delay.connect("timeout", self, "_on_Laser_delay_timeout")
		delay.wait_time = LASER_DELAY

	if "magic" in msg:
		delay.connect("timeout", self, "_on_Magic_delay_timeout")
		delay.wait_time = MAGIC_DELAY
	delay.start()


func exit() -> void:
	projectiles_to_spawn = projectiles_spawn_default
	delay.stop()


func shoot_projectiles(animation: String, spawn_position: Position2D) -> void:
	owner.skin.play(animation)
	owner.skin.anim.queue("idle")
	sfx.play_sound()
	projectiles_to_spawn = projectiles_to_spawn - 1
	spawn_position.get_child(projectiles_to_spawn).direction = owner.look_direction
	spawn_position.get_child(projectiles_to_spawn).launch()


func spawn_laser() -> void:
	var laser = LASER_SCENE.instance()
	laser_spawn_position.add_child(laser)
	laser.position = Vector2(8 * laser_spawn_position.get_child_count(), 0)
	laser.call_deferred("spawn")


func spawn_magic() -> void:
	var magic = MAGIC_SCENE.instance()
	magic_spawn_position.add_child(magic)
	magic.position = Vector2(16 * magic_spawn_position.get_child_count(), 0)
	magic.call_deferred("spawn")


func _on_Laser_delay_timeout() -> void:
	shoot_projectiles("attack_2", laser_spawn_position)
	if projectiles_to_spawn > 0:
		delay.start()
		return

	_state_machine.transition_to("Attack/Casting", {magic = true})
	delay.disconnect("timeout", self, "_on_Laser_delay_timeout")


func _on_Magic_delay_timeout() -> void:
	shoot_projectiles("attack_1", magic_spawn_position)

	if projectiles_to_spawn > 0:
		delay.start()
		return

	delay.disconnect("timeout", self, "_on_Magic_delay_timeout")
	delay.connect("timeout", self, "_on_Vulnerable_delay_timeout")
	delay.start()


func _on_Vulnerable_delay_timeout() -> void:
	_state_machine.transition_to("Vulnerable")
	delay.disconnect("timeout", self, "_on_Vulnerable_delay_timeout")
