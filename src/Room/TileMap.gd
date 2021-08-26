extends TileMap


func _ready():
	if not has_node("EndOfLevel"):
		printerr("EndOfLevel node is missing for %s : %s" % [name, get_path()])
