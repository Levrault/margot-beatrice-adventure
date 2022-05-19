extends Label
class_name TimeFormat

const TIME_SS_MS_FORMAT = "%02ds %02dms"
const TIME_MM_SS_MS_FORMAT = "%02dm %02ds %02dms"

var _elapsed_time := 0.0

onready var _tween := $Tween


func _ready():
	Events.connect("level_completion_time_emitted", self, "_on_Level_completion_time_emitted")


# convert milisecondes to readable string
# eg. 1085587 will be 18Min 5s 587ms
# eg. 5587 will be 5s 587ms
func format_time(current_time: float) -> String:
	var minutes := current_time / 60
	var seconds := fmod(current_time, 60)
	var milliseconds := fmod(current_time, 1) * 100

	if minutes == 0:
		text = TIME_SS_MS_FORMAT % [seconds, milliseconds]
	else:
		text = TIME_MM_SS_MS_FORMAT % [minutes, seconds, milliseconds]
	return text


func start_tween() -> void:
	_tween.interpolate_method(
		self, "format_time", 0, _elapsed_time, .5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR
	)
	_tween.start()


func _on_Level_completion_time_emitted(time: float) -> void:
	print_debug("level finished in %s" % String(time))
	_elapsed_time = time
