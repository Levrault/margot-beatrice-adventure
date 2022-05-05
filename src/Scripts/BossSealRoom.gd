extends Node2D
class_name BossSealRoom

export var boss_path := NodePath()

onready var player_detector := $PlayerDetector
onready var crates := $Crates
onready var anim := $AnimationPlayer


func _ready():
	var boss = get_node_or_null(boss_path)
	if boss == null:
		printerr("%s - object_path is invalid" % get_name())
		return
	player_detector.connect("player_entered", self, "_on_Player_entered")
	boss.connect("tree_exited", self, "_on_Boss_tree_exited")


func _on_Player_entered(player: Player) -> void:
	player_detector.queue_free()
	MusicPlayer.change_track("electronic_fantasy")
	for crate in crates.get_children():
		crate.active = true
	Events.emit_signal("boss_state_changed_to", "Attack/Casting", {laser = true})


func _on_Boss_tree_exited() -> void:
	for crate in crates.get_children():
		crate.active = false
	anim.play("reveal_collectables")
