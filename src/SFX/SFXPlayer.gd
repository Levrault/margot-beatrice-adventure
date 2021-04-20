extends AudioStreamPlayer2D

export var min_pitch_scale := .95
export var max_pitch_scale := 1.15

var rng = RandomNumberGenerator.new()


func play_sound() -> void:
	pitch_scale = rng.randf_range(min_pitch_scale, max_pitch_scale)
	play()
