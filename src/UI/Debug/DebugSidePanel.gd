extends Control

onready var anchor = $PanelContainer/MarginContainer/VBoxContainer/Anchor/Value
onready var gamepad = $PanelContainer/MarginContainer/VBoxContainer/Gamepad/Value
onready var gamepad_layout = $PanelContainer/MarginContainer/VBoxContainer/GamepadLayout/Value
onready var level = $PanelContainer/MarginContainer/VBoxContainer/Level/Value
onready var player_position = $PanelContainer/MarginContainer/VBoxContainer/PlayerPosition/Value
onready var player_state = $PanelContainer/MarginContainer/VBoxContainer/PlayerState/Value
onready var hits_taken = $PanelContainer/MarginContainer/VBoxContainer/HitsTaken/Value
onready var game_over = $PanelContainer/MarginContainer/VBoxContainer/GameOver/Value
onready var spawn_point = $PanelContainer/MarginContainer/VBoxContainer/SpawnPoint/Value


func _ready() -> void:
	yield(owner, "ready")
	if not ProjectSettings.get_setting("game/debug"):
		queue_free()
	Events.connect("player_moved", self, "_on_Player_moved")
	InputManager.connect("device_changed", self, "_on_Device_changed")


func _on_Player_moved(player: Player) -> void:
	player_position.text = String(
		Vector2(round(player.global_position.x), round(player.global_position.y))
	)
	player_state.text = String(player.state_machine.state_name)
	hits_taken.text = String(Game.stats.hits_taken)
	game_over.text = String(Game.stats.game_over)
	spawn_point.text = String(player.spawn_position)

	if SceneManager.anchor:
		anchor.text = SceneManager.anchor.get_name()


func _on_Device_changed(device: String, device_index: int) -> void:
	gamepad.text = "%s - %s" % [device, String(device_index)]
	gamepad_layout.text = Config.values.gamepad_layout.gamepad_layout
