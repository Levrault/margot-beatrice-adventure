extends Area2D

signal player_entered
signal player_exited


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")


func _on_Body_entered(body: Player) -> void:
	emit_signal("player_entered")


func _on_Body_exited(body: Player) -> void:
	emit_signal("player_exited")
