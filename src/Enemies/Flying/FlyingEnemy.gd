extends Enemy

var target: Player = null

onready var player_detector := $PlayerDetector


func _ready() -> void:
	player_detector.get_node("CollisionShape2D").disabled = true
