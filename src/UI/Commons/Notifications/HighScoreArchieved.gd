extends Control

onready var anim := $AnimationPlayer


func _ready():
	Events.connect("new_high_score_archived", self, "_on_New_high_score_archieved")


func _on_New_high_score_archieved() -> void:
	anim.play("show")
