extends Node2D


func _ready():
	yield(owner, "ready")
	owner.connect("focus_entered", self, "_on_Focus_entered")
	owner.connect("focus_exited", self, "_on_Focus_exited")


func _on_Focus_entered() -> void:
	print(owner.name)
	owner.get_node("AnimationPlayer").play("focus")
	owner.get_node("FocusAudio").play()


func _on_Focus_exited() -> void:
	owner.get_node("AnimationPlayer").play("unfocus")
