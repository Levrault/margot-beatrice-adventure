# Save player progression
extends Node2D
class_name EndOfLevel


func _ready() -> void:
	Events.connect("game_saved", self, "_on_Saved_successfull")
	$Area2D.connect("body_entered", self, "_on_body_entered")


func _on_Saved_successfull() -> void:
	print("in")


func _on_body_entered(body: Player) -> void:
	print("_on_body_entered")
