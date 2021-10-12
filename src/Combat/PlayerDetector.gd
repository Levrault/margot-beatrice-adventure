extends Area2D

signal player_entered(body)
signal player_exited(body)

var disabled := false setget set_disabled


func _ready() -> void:
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")

	if not has_node("CollisionShape2D"):
		printerr("PlayerDectector node is missing for %s : %s" % [name, get_path()])


func set_disabled(value: bool) -> void:
	get_node("CollisionShape2D").set_deferred("disabled", value)


func _on_Body_entered(body: Player) -> void:
	emit_signal("player_entered", body)


func _on_Body_exited(body: Player) -> void:
	emit_signal("player_exited", body)
