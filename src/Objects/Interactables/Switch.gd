extends Area2D

export var object_path := NodePath()

onready var anim := $AnimationPlayer


func _ready():
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")
	set_process_input(false)

	if get_node_or_null(object_path) == null:
		printerr("%s - object_path is invalid" % get_name())
		return


func _input(event) -> void:
	if event.is_action_pressed("interaction"):
		anim.play("switched")
		set_process_input(false)
		disconnect("body_entered", self, "_on_Body_entered")
		disconnect("body_exited", self, "_on_Body_exited")
		monitoring = false
		get_node_or_null(object_path).anim.play("destroy")


func _on_Body_entered(body: Player) -> void:
	anim.play("interactable")
	set_process_input(true)


func _on_Body_exited(body: Player) -> void:
	anim.play_backwards("interactable")
	set_process_input(false)
