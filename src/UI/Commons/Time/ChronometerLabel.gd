extends Label


# convert milisecondes to readable string
# eg. 1085587 will be 18Min 5s 587ms
# eg. 5587 will be 5s 587ms
func format_time(current_time: float) -> String:
	print(current_time)
	text = "%s" % fmod(current_time, 60)
	return text
