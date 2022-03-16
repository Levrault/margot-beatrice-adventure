extends Control


var go_to_scene_path := ""


func _ready():
	Events.connect("loading_transtion_started", self, "_on_Loading_transition_started")


func load_level() -> void:
	AsyncLoading.goto_scene(go_to_scene_path)


func _on_Loading_transition_started(go_to_scene: String) -> void:
	go_to_scene_path = go_to_scene
	$IrisShot/AnimationPlayer.play("transition")
