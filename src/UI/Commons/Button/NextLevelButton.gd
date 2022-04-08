extends GenericButton


func _on_Pressed() -> void:
	Events.emit_signal("loading_transition_started", "res://src/Levels/%s.tscn" % owner.next_level)
	Game.stats.game_over = 0
	Game.stats.hits_taken = 0
