extends Control

onready var anim := $AnimationPlayer

func _ready():
	Events.connect("game_over", self, "_on_Game_over")


func _on_Game_over() -> void:
	anim.play("show")
