extends AudioStreamPlayer

export var min_pitch_scale := .95
export var max_pitch_scale := 1.15
export var repeat_mode := true

var rng = RandomNumberGenerator.new()


func play_sound() -> void:
	if not repeat_mode and playing:
		return

	pitch_scale = rng.randf_range(min_pitch_scale, max_pitch_scale)
	play()
