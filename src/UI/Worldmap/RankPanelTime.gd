extends Label

export var signal_to_connect := ""


func _ready():
	assert(not signal_to_connect.empty())
	Events.connect(signal_to_connect, self, "_on_Worldmap_rank_time_changed")


func _on_Worldmap_rank_time_changed(time_in_sec: float) -> void:
	text = "%s.000s" % time_in_sec
