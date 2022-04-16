extends Node2D

const UNALLOWED_STATES := ["Hurt", "Die", "Spawn"]

export (Character.Playable) var character = Character.Playable.FOX

var selected_character = Character.Playable.FOX setget _set_selected_character
var character_data := {}
var _direction := 1

onready var characters: Node2D = $Characters
onready var momentum: Momentum = $Momentum
onready var tween := $Tween
onready var effects := $Effects


func _ready() -> void:
	yield(owner, "ready")
	Events.connect("room_loaded", self, "_on_Room_loaded")
	Events.connect("game_paused", self, "_on_Game_paused")
	Events.connect("game_unpaused", self, "_on_Game_unpaused")
	owner.stats.connect("is_invulnerable", effects, "_on_Invulnerable_stop")

	self.selected_character = character
	owner.skin = characters.get_node(Character.list[selected_character]).skin
	owner.skin.set_process(true)


func _unhandled_input(event) -> void:
	if UNALLOWED_STATES.has(owner.state_machine.state_name):
		return

	if (
		event.is_action_pressed("switch_to_squirrel")
		and selected_character != Character.Playable.SQUIRREL
	):
		self.selected_character = Character.Playable.SQUIRREL
		return

	if (
		event.is_action_pressed("switch_to_rabbit")
		and selected_character != Character.Playable.RABBIT
	):
		self.selected_character = Character.Playable.RABBIT
		return

	if event.is_action_pressed("switch_to_fox") and selected_character != Character.Playable.FOX:
		self.selected_character = Character.Playable.FOX
		return

	if event.is_action_pressed("next_character"):
		if selected_character + 1 > Character.Playable.SQUIRREL: # last character
			self.selected_character = Character.Playable.FOX
			return
		self.selected_character += 1
		return

	if event.is_action_pressed("prev_character"):
		if selected_character - 1 < Character.Playable.FOX: # last character
			self.selected_character = Character.Playable.SQUIRREL
			return
		self.selected_character -= 1
		return


func _set_selected_character(value: int) -> void:
	selected_character = value
	Character.selected = value
	switch_to(Character.list[value])


func exit() -> void:
	owner.is_handling_input = true
	tween.interpolate_property(owner.skin, "modulate:a", .1, 1, momentum.DURATION)
	tween.start()


func switch_to(new_character: String) -> void:
	print_debug("Changed to %s" % new_character)
	momentum.start()
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

	if anim_to_play == "dash":
		anim_to_play = "fall"
	owner.skin.play(anim_to_play)
	Events.emit_signal("player_character_changed")
	exit()


func _on_Room_loaded() -> void:
	if selected_character == Character.selected:
		return
	selected_character = Character.selected
	switch_to(Character.list[selected_character])


func _on_Game_paused() -> void:
	set_process_unhandled_input(false)


func _on_Game_unpaused() -> void:
	set_process_unhandled_input(true)
