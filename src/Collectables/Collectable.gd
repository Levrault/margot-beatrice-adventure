extends Area2D

export (Character.Playable) var character = Character.Playable.fox

onready var collision := $CollisionShape2D
onready var skin := $Sprite
onready var feedback := $CollectableFeedback


func _ready() -> void:
	connect("body_entered", self, "_on_Player_entered")
	Events.connect("player_character_changed", self, "_on_Player_character_changed")
	feedback.anim.connect("animation_finished", self, "_on_Feedback_animation_finished")


func _on_Player_character_changed() -> void:
	if character != Character.selected:
		collision.disabled = true
		return
	collision.disabled = false


func _on_Player_entered(body: Player) -> void:
	Character.update_score()
	skin.hide()
	feedback.anim.play("collected")


func _on_Feedback_animation_finished(anim_name: String) -> void:
	if anim_name == "collected":
		queue_free()
