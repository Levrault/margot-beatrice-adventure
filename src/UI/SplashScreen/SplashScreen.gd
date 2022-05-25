extends Control


func _ready():
	if Game.splash_screen_viewed:
		owner.get_node("MusicController").restart()
		queue_free()
		return
	owner.get_node("TitleScreenPage").hide()


func finished() -> void:
	Menu.navigate_to("TitleScreenPage")
	Menu.current_route = "TitleScreenPage"
	Game.splash_screen_viewed = true
	owner.get_node("MusicController").restart()
	queue_free()
