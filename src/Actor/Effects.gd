# Apply effects depending on character's state
extends Node2D

const FLASH_DURATION := .2

onready var tween := $Tween


# Start flash animation when owner take damage
func damage_effect() -> void:
	tween.repeat = true
	for character in owner.characters.get_children():
		tween.interpolate_property(
			character.skin, "modulate", character.skin.modulate, Color.darkred, FLASH_DURATION
		)
	tween.start()


# Stop flash animation when owner take damage
# @param {bool} is_invulnerable
func _on_Invulnerable_stop(is_invulnerable: bool) -> void:
	if is_invulnerable:
		return
	tween.repeat = false
	for character in owner.characters.get_children():
		tween.interpolate_property(
			character.skin, "modulate", character.skin.modulate, Color(1, 1, 1), FLASH_DURATION
		)
	tween.start()
