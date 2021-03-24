extends Label

var _level_started_time := 0.0
var _elapsed_time := 0.0

onready var _tween := $Tween


func _ready():
	yield(get_tree().get_root(), "ready")

	Events.connect("level_finished", self, "_on_Level_finished")

	# time to completed the level
	_level_started_time = OS.get_ticks_msec()


# convert milisecondes to readable string
# eg. 1085587 will be 18Min 5s 587ms
# eg. 5587 will be 5s 587ms
func format_time(current_time: int) -> void:
	# only ms
	if current_time < 1000:
		text = tr("ui_time_format_ss_ms") % [0, current_time]
		return

	var string_time := String(current_time)

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


func _on_Level_finished() -> void:
	_elapsed_time = OS.get_ticks_msec() - _level_started_time
