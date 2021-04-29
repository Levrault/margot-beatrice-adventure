extends Label

var _level_started_time := 0.0
var _elapsed_time := 0.0

onready var _tween := $Tween


func _ready():
	Events.connect("level_completion_time_emitted", self, "_on_Level_completion_time_emitted")


# convert milisecondes to readable string
# eg. 1085587 will be 18Min 5s 587ms
# eg. 5587 will be 5s 587ms
func format_time(current_time: float) -> void:
	current_time = stepify(current_time, 0.001)

	# if the level has take more than one hour
	if current_time > 3600:
		print("one hour")
		text = tr("ui_time_take_too_long")
		return

	# only ms
	if current_time < 1:
		text = tr("ui_time_format_ss_ms") % [0, current_time]
		return

	var string_time := String(current_time).replace('.', '')
	var ms := string_time.substr(string_time.length() - 3, string_time.length())
	string_time = string_time.substr(0, string_time.length() - 3)
	var ss := string_time
	var mm := floor(float(ss) / 60)
	if mm == 0:
		text = tr("ui_time_format_ss_ms") % [ss, ms]
		return

	ss = String(fmod(float(ss), 60.0))
	text = (
		tr("ui_time_format_mm_ss_ms")
		% [
			String(mm),
			ss,
			ms,
		]
	)


func start_tween() -> void:
	_tween.interpolate_method(
		self, "format_time", 0, _elapsed_time, .5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR
	)
	_tween.start()


func _on_Level_completion_time_emitted(time: float) -> void:
	print_debug("level finished in %s" % String(time))
	_elapsed_time = stepify(time, 0.001)
