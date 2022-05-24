extends Control


func _ready():
	owner.get_node("TitleScreenPage").hide()


func finished() -> void:
	Menu.navigate_to("TitleScreenPage")
	Menu.current_route = "TitleScreenPage"
	owner.get_node("MusicController").restart()
	queue_free()
