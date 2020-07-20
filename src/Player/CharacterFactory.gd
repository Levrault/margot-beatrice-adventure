extends Node2D

export (Character.Playable) var character = Character.Playable.fox

var selected_character = Character.Playable.fox
var character_data := {}
var _direction := 1

onready var wheel = $Wheel
onready var characters: Node2D = $Characters


func _ready() -> void:
	yield(owner, "ready")
	Events.connect("room_loaded", self, "_on_Room_loaded")

	selected_character = character
	wheel.hide()
	wheel.next(Character.list[selected_character])
	switch_to(Character.list[selected_character])


func _unhandled_input(event) -> void:
	if not owner.is_on_floor():
		return

	if not wheel.visible and event.is_action_pressed("character_wheel"):
		owner.is_handling_input = false
		wheel.show()
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
		owner.is_handling_input = true
		wheel.hide()
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

	owner.horizontal_mirror(_direction)
	owner.skin.play(anim_to_play)
