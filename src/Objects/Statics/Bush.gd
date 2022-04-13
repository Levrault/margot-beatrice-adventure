extends Sprite

var leaves_particules_scene := preload("res://src/Particules/LeavesParticules.tscn")


func _ready():
	$Area2D.connect("body_entered", self, "_on_Body_entered")


func _on_Body_entered(body: Player) -> void:
	if ! body:
		return
	$AnimationPlayer.play("shake")

	var leaves = leaves_particules_scene.instance()

	if body.global_position > global_position:
		leaves.scale.x *= -1
	add_child(leaves)
