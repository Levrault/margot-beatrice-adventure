extends Label


func _ready():
	Events.connect("worldmap_rank_changed", self, "_on_Worldmap_rank_changed")


func _on_Worldmap_rank_changed(rank: String) -> void:
	if rank.empty():
		text = "-"
		return
	text = rank
