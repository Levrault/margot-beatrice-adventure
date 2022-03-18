extends Area2D

export (Character.Playable) var character = Character.Playable.FOX

onready var collision := $CollisionShape2D
onready var skin := $Sprite
onready var feedback := $CollectableFeedback
onready var sfx := $SFXCollectable


func _ready() -> void:
	connect("body_entered", self, "_on_Player_entered")
	Events.connect("player_character_changed", self, "_on_Player_character_changed")
	feedback.anim.connect("animation_finished", self, "_on_Feedback_animation_finished")

	_on_Player_character_changed()


func _on_Player_character_changed() -> void:
	if character != Character.selected:
		collision.disabled = true
		return
	collision.disabled = false


func _on_Player_entered(body: Player) -> void:
	Character.update_score()
	skin.hide()
	collision.call_deferred("set", "disabled", true)
	feedback.anim.play("collected")
	sfx.play_sound()


func _on_Feedback_animation_finished(anim_name: String) -> void:
	if anim_name == "collected":
		queue_free()
