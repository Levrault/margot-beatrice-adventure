extends Node2D

export (Character.Playable) var character = Character.Playable.fox

var selected_character = character
var character_data := {}
var _direction := 1

onready var wheel = $Wheel
onready var characters: Node2D = $Characters


func _ready() -> void:
	yield(owner, "ready")
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

	if event.is_action_pressed("move_left"):
		selected_character += 1
		if selected_character >= Character.list.size():
			selected_character = 0
		wheel.next(Character.list[selected_character])
		Character.selected = selected_character
		return
	if event.is_action_pressed("move_right"):
		owner.is_handling_input = false
		selected_character -= 1
		if selected_character < 0:
			selected_character = Character.list.size() - 1
		wheel.prev(Character.list[selected_character])
		Character.selected = selected_character
		return

	if event.is_action_pressed("jump"):
		switch_to(Character.list[selected_character])
		owner.is_handling_input = true
		wheel.hide()
		return


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
