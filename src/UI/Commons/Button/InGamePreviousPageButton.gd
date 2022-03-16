# In-game previous page button
# @category: Button
extends PreviousPageButton


func _ready() -> void:
	show()


func _on_Pressed() -> void:
	._on_Pressed()
	if Menu.history.size() == 0:
		Events.emit_signal("in_game_menu_hidden")


func _on_Menu_route_changed(route: String) -> void:
	return
