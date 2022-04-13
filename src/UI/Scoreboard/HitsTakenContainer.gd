extends ScoreContainer


func start_tween() -> void:
	_tween.interpolate_method(
		self, "_format_text", 0, Game.stats.hits_taken, .5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR
	)
	_tween.start()
