extends Control

onready var level = $PanelContainer/MarginContainer/VBoxContainer/Level/Value
onready var camera = $PanelContainer/MarginContainer/VBoxContainer/Camera/Value
onready var anchor = $PanelContainer/MarginContainer/VBoxContainer/Anchor/Value
onready var gamepad = $PanelContainer/MarginContainer/VBoxContainer/Gamepad/Value
onready var gamepad_layout = $PanelContainer/MarginContainer/VBoxContainer/GamepadLayout/Value
onready var player_position = $PanelContainer/MarginContainer/VBoxContainer/PlayerPosition/Value
onready var player_state = $PanelContainer/MarginContainer/VBoxContainer/PlayerState/Value
onready var hits_taken = $PanelContainer/MarginContainer/VBoxContainer/HitsTaken/Value
onready var game_over = $PanelContainer/MarginContainer/VBoxContainer/GameOver/Value
onready var spawn_point = $PanelContainer/MarginContainer/VBoxContainer/SpawnPoint/Value
onready var max_gems = $PanelContainer/MarginContainer/VBoxContainer/Gems/Value
onready var max_carrots = $PanelContainer/MarginContainer/VBoxContainer/Carrots/Value
onready var max_acorns = $PanelContainer/MarginContainer/VBoxContainer/Acorns/Value


func _ready() -> void:
	Events.connect("collectable_max_value_counted", self, "_on_Collectable_max_value_counted")

	if not Project.get_setting("sidepanel"):
		queue_free()

	yield(owner, "ready")
	Events.connect("player_moved", self, "_on_Player_moved")
	Events.connect("camera_changed", self, "_on_Camera_changed")
	InputManager.connect("device_changed", self, "_on_Device_changed")
	level.text = Game.current_level


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug_panel"):
		if visible:
			hide()
		else:
			show()
		return


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


func _on_Camera_changed(name: String) -> void:
	camera.text = name


func _on_Collectable_max_value_counted(gems: int, acorns: int, carrots: int) -> void:
	max_gems.text = String(gems)
	max_carrots.text = String(acorns)
	max_acorns.text = String(carrots)
