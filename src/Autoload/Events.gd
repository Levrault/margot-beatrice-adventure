# Signal Autoload Pattern
# @see https://www.youtube.com/watch?v=S6PbC4Vqim4
extends Node

############
## DEBUG ##
############
signal screenshot_started
signal screenshot_ended

############
### Game ###
############

# boss
signal boss_state_changed_to(state, msg)

# camera
signal camera_changed(name)
signal camera_offset_changed(offset)
signal camera_offset_resetted
signal camera_anchor_changed

# cinematic
signal cinematic_intro_started
signal cinematic_intro_ended
signal cinematic_started
signal cinematic_ended

# collectable
signal collectable_collected(character, score)
signal collectable_max_value_counted(gems, acorns, carrots)

# controller
signal controller_changed(controller)

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

#engine
signal engine_time_scale_changed(value)

# game over
signal game_over

# high score
signal new_high_score_archived

# in-game interfaces
signal game_paused
signal game_unpaused

# input
signal keybinding_started(scancode)
signal keybinding_canceled
signal keybinding_resetted
signal keybinding_key_selected(scancode)

# level
signal level_started
signal level_finished
signal level_completion_time_emitted(time)

# notification
signal notification_started(text, size)

# player
signal player_targeted(player)
signal player_moved(player)
signal player_room_entered(position)
signal player_choice_started
signal player_character_changed
signal player_input_disabled
signal player_input_enabled
signal player_hud_disabled
signal player_hud_enabled
signal player_max_health_changed(value)

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

# serialize
signal game_saved

# spawn
signal spawn_position_changed(new_position)

# transitions
signal transition_started(anim_name)
signal transition_mid_animated
signal transition_finished

# worldmap
signal worldmap_level_selected(data)
signal worldmap_level_hidden

############
#### UI ####
############

# config
signal config_file_saved
signal config_file_loaded

# field
signal field_description_changed(description)
signal focused_row_changed(row)

# fieldset
signal fieldset_cleared(fieldset)
signal fieldset_inner_field_navigated(focused_field)

# gamepad binding
signal gamepad_listening_started
signal gamepad_layout_changed
signal gamepad_stick_layout_changed(joy_actions, translation_key)

# in-game
signal in_game_menu_hidden

# keybinding
signal key_listening_started(field, button, scancode)

# loading
signal loading_transition_started(go_to_scene)

# locale
signal locale_changed

# menu
signal menu_route_changed(route)
signal menu_transition_started(anim_name)
signal menu_transition_mid_animated
signal menu_transition_finished

# navigation
signal navigation_disabled
signal navigation_enabled

# overlay
signal overlay_displayed
signal overlay_hidden

# profile
signal erase_profile_dialog_displayed(for_profile, button)
signal erase_profile_dialog_confirm_button_pressed
signal new_profile_page_displayed(for_profile)
signal new_profile_created(profile)

# Required field unmapped
signal required_field_unmapped_displayed(unmapped_fields)

# save icon
signal save_notification_enabled

# user
signal user_has_changed_gamepad_bindind

# worldmap
signal worldmap_level_name_changed(new_text)
signal worldmap_preview_changed(new_texture)
signal worldmap_best_time_changed(best_time)
signal worldmap_rank_changed(rank)
signal worldmap_preview_animation_activated
signal worldmap_acorns_percentage_changed(value, max_value)
signal worldmap_carrots_percentage_changed(value, max_value)
signal worldmap_gems_percentage_changed(value, max_value)
signal worldmap_rank_s_time_changed(time_in_sec)
signal worldmap_rank_a_time_changed(time_in_sec)
signal worldmap_rank_b_time_changed(time_in_sec)
