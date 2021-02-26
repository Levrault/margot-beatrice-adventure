extends Particles2D

onready var _timer = $Timer


func _ready():
	_timer.wait_time = lifetime + 0.5
	_timer.connect("timeout", self, "_on_Timeout", [], CONNECT_ONESHOT)
	_timer.start()


func _on_Timeout() -> void:
	queue_free()
