extends Stats


func _ready():
	Events.connect("player_max_health_changed", self, "_on_Player_max_health_changed")
	max_health = Config.values.accessibility.player_health
	health = max_health


func _on_Player_max_health_changed(value: int) -> void:
	print_debug("Player max heatlh is now %s" % value)
	max_health = value
	owner.life_bar.max_value = max_health
	owner.life_bar.value = max_health
	reset()
