extends Label

const TIME_FORMAT = "%02d"


func format_time(time: float) -> String:
	text = TIME_FORMAT % (fmod(time, 1) * 100)
	return text
