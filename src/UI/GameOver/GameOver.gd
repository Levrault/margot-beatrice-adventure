extends Control


func _ready():
	Events.connect("game_over", $AnimationPlayer, "play", ["show"])
