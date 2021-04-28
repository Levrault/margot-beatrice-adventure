# Signal Autoload Pattern
# @see https://www.youtube.com/watch?v=S6PbC4Vqim4
extends Node

# camera
signal camera_offset_changed(offset)
signal camera_offset_resetted
signal camera_anchor_changed

# controller
signal controller_changed(controller)

# collectable
signal collectable_collected(character, score)
signal collectable_max_value_counted(gems, acorns, carrots)

# dialogue
signal dialogue_started
signal dialogue_changed(name, portrait, message)
signal dialogue_text_displayed
signal dialogue_last_text_displayed
signal dialogue_finished
signal dialogue_last_dialogue_displayed
signal dialogue_animation_skipped
signal dialogue_choices_changed(choices)
signal dialogue_choices_displayed
signal dialogue_choices_finished(choices)
signal dialogue_choices_pressed
signal dialogue_timed_out
signal dialogue_timed(value)

# cinematic
signal cinematic_started
signal cinematic_ended

# serialize
signal game_saved

# in-game interfaces
signal game_paused
signal game_unpaused

# game over
signal game_over

# menu
signal menu_route_changed(route)

# notification
signal notification_started(text, size)

# player
signal player_moved(player)
signal player_room_entered(position)
signal player_choice_started
signal player_character_changed

# input
signal keybinding_started(scancode)
signal keybinding_canceled
signal keybinding_resetted
signal keybinding_key_selected(scancode)

# level
signal level_started
signal level_finished
signal level_completion_time_emitted(time)

# room
signal room_limit_changed(
	left,
	top,
	right,
	bottom,
)
signal room_transition_started
signal room_transition_ended
signal room_loaded

# transitions
signal transition_started(anim_name)
signal transition_mid_animated
signal transition_finished

# worldmap
signal worldmap_level_selected(data)
signal worldmap_level_hidden
