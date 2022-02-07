extends Label


func _ready():
	text = "v" + ProjectSettings.get_setting("game/game_version")
