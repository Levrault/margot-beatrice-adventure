extends Node2D

export (Character.Playable) var character = Character.Playable.FOX

var selected_character = Character.Playable.FOX
var character_data := {}
var _direction := 1

onready var wheel = $Wheel
onready var characters: Node2D = $Characters


func _ready() -> void:
	yield(owner, "ready")
	Events.connect("room_loaded", self, "_on_Room_loaded")
	Events.connect("game_paused", self, "_on_Game_paused")
	Events.connect("game_unpaused", self, "_on_Game_unpaused")

	selected_character = character
	Character.selected = character
	wheel.hide()
	wheel.next(Character.list[selected_character])
	owner.skin = characters.get_node(Character.list[selected_character]).skin
	owner.skin.set_process(true)


func _unhandled_input(event) -> void:
	if not owner.is_on_floor():
		return

	if not wheel.visible and event.is_action_pressed("character_wheel"):
		owner.is_handling_input = false
		wheel.show()
		get_tree().paused = true
		return

	if not wheel.visible:
		return

	# prevent axis navigation to emit multiples press event
	if InputManager.controller == InputManager.XBOX:
		# use input with a deadzone of 1, see project settings
		if event.is_action_pressed("move_character_wheel_left"):
			_next_character()
			return

		if event.is_action_pressed("move_character_wheel_right"):
			_prev_character()
			return

	if InputManager.controller == InputManager.KEYBOARD:
		if event.is_action_pressed("move_left"):
			_next_character()
			return
		if event.is_action_pressed("move_right"):
			_prev_character()
			return

	if event.is_action_pressed("jump"):
		switch_to(Character.list[selected_character])
		wheel.hide()
		get_tree().paused = false
		return


func _next_character() -> void:
	selected_character += 1
	if selected_character >= Character.list.size():
		selected_character = 0
	wheel.next(Character.list[selected_character])
	Character.selected = selected_character


func _prev_character() -> void:
	owner.is_handling_input = false
	selected_character -= 1
	if selected_character < 0:
		selected_character = Character.list.size() - 1
	wheel.prev(Character.list[selected_character])
	Character.selected = selected_character


func _on_Room_loaded() -> void:
	if selected_character == Character.selected:
		return
	selected_character = Character.selected
	wheel.next(Character.list[selected_character])
	switch_to(Character.list[selected_character])


func switch_to(new_character: String) -> void:
	print_debug("Changed to %s" % new_character)

	owner.skin.connect("shader_finished", self, "_on_Shader_teleport_in_finished", [new_character])
	owner.skin.execute_shader("teleport_in")


func _on_Shader_teleport_in_finished(anim_name: String, new_character: String) -> void:
	owner.skin.disconnect("shader_finished", self, "_on_Shader_teleport_in_finished")

	var anim_to_play := "idle"
	for child in characters.get_children():
		if not child.get_name() == new_character:
			if child.visible:
				anim_to_play = child.skin.current_anim
			child.hide()
			child.set_process(false)
			continue

		owner.change_state_data(child.data)
		child.set_process(true)
		child.show()

		# keep current direction
		if owner.skin != null:
			_direction = owner.skin.scale.x

		owner.skin = child.skin

	owner.flip(_direction)
	owner.skin.play(anim_to_play)
	Events.emit_signal("player_character_changed")

	owner.skin.connect("shader_finished", self, "_on_Shader_teleport_out_finished")
	owner.skin.execute_shader("teleport_out")


func _on_Shader_teleport_out_finished(anim_name: String) -> void:
	owner.is_handling_input = true
	owner.skin.disconnect("shader_finished", self, "_on_Shader_teleport_out_finished")


func _on_Game_paused() -> void:
	pause_mode = Node.PAUSE_MODE_INHERIT


func _on_Game_unpaused() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
