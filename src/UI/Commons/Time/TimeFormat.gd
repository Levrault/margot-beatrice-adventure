extends Label
class_name TimeFormat

const TIME_FORMAT_SS_MS = "{ss}s {ms}ms"
const TIME_FORMAT_MM_SS_MS = "{mm}m {ss}s {ms}ms"

var _elapsed_time := 0.0

onready var _tween := $Tween


func _ready():
	Events.connect("level_completion_time_emitted", self, "_on_Level_completion_time_emitted")


# convert milisecondes to readable string
# eg. 1085587 will be 18Min 5s 587ms
# eg. 5587 will be 5s 587ms
func format_time(current_time: float) -> String:
	current_time = stepify(current_time, 0.001)

	# only ms
	if current_time < 1:
		text = TIME_FORMAT_SS_MS.format({ss = 0, ms = current_time})
		return text

	# formatting time to string (force ms)
	var time_string := format_time_to_string(current_time)
	var ms := time_string.substr(time_string.length() - 3, time_string.length())
	time_string = time_string.substr(0, time_string.length() - 3)

	var ss := time_string
	var mm := floor(float(ss) / 60)

	if mm == 0:
		text = TIME_FORMAT_SS_MS.format({ss = ss, ms = ms})
		return text

	ss = String(fmod(float(ss), 60.0))
	text = TIME_FORMAT_MM_SS_MS.format({mm = String(mm), ss = ss, ms = ms})
	return text


func start_tween() -> void:
	_tween.interpolate_method(
		self, "format_time", 0, _elapsed_time, .5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR
	)
	_tween.start()


func format_time_to_string(time: float) -> String:
	var time_string := String(time)
	var dot_position := time_string.find(".")

	# e.g. 59
	if dot_position == -1:
		time_string += ".000"
		return time_string.replace('.', '')

	# e.g. 59.1 || 59.11
	var ms_string := time_string.right(dot_position + 1)
	if ms_string.length() < 3:
		while ms_string.length() < 3:
			ms_string += "0"
			time_string += "0"

	return time_string.replace('.', '')


func _on_Level_completion_time_emitted(time: float) -> void:
	print_debug("level finished in %s" % String(time))
	_elapsed_time = stepify(time, 0.001)
