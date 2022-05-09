extends Label


func format_completed(levels: Dictionary) -> String:
	var max_value_per_level = 100.0 / levels.size()
	var step_by_rank = max_value_per_level / 4
	var value := 0
	for key in levels:
		var level = levels[key]
		
		if level.rank == "S":
			value += max_value_per_level
		elif level.rank == "A":
			value += max_value_per_level - step_by_rank
		elif level.rank == "B":
			value += max_value_per_level - (step_by_rank * 2)
		elif level.rank == "C":
			value += max_value_per_level - (step_by_rank * 3)
		
	return String(round(value))
