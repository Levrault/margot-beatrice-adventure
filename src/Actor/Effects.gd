# Apply effects depending on character's state
extends Node2D

const FLASH_DURATION := .2

onready var tween := $Tween


func _ready() -> void:
	yield(owner, "ready")
	owner.stats.connect("damage_taken", self, "_on_Damage_taken")
	owner.stats.connect("is_invulnerable", self, "_on_Invulnerable_stop")


# Start flash animation when owner take damage
func _on_Damage_taken() -> void:
	tween.repeat = true
	tween.interpolate_property(
		owner.skin, "modulate", owner.skin.modulate, Color.darkred, FLASH_DURATION
	)
	tween.start()


# Stop flash animation when owner take damage
# @param {bool} is_invulnerable
func _on_Invulnerable_stop(is_invulnerable: bool) -> void:
	if is_invulnerable:
		return
	tween.repeat = false
	tween.interpolate_property(
		owner.skin, "modulate", owner.skin.modulate, Color(1, 1, 1), FLASH_DURATION
	)
	tween.start()
