extends Label

const RANK_100 := "S"
const RANK_80 := "A"
const RANK_60 := "B"
const RANK_LOW := "C"

var _max_collected := 0
var _elapsed_time := 0.0


func _ready():
	Events.connect("collectable_max_value_counted", self, "_on_Collectable_max_value_counted")
	Events.connect("level_completion_time_emitted", self, "_on_Level_completion_time_emitted")


# based on
# - Number of game over
# - Hit taken
# - Collectables
# - Time
func start_tween() -> void:
	var rank := RANK_LOW
	var total_collected := 0
	for key in Character.score:
		total_collected += Character.score[key]

	var percentage := compute_percentage(total_collected, _max_collected)

	# S is 100%
	if percentage == 100 and Game.stats.game_over == 0 and Game.stats.hits_taken == 0 and _elapsed_time <= owner.time_for_rank_100:
		rank = RANK_100
	elif percentage >= 80 and Game.stats.game_over <= 1 and Game.stats.hits_taken <= 5 and _elapsed_time <= owner.time_for_rank_80:
		rank = RANK_80
	elif percentage >= 60 and Game.stats.game_over <= 2 and Game.stats.hits_taken <= 10 and _elapsed_time <= owner.time_for_rank_80:
		rank = RANK_60

	text = rank


func compute_percentage(value, max_value) -> int:
	var percentage = value * 100 / max_value if value > 0 else 0
	return int(round(percentage))


func _on_Collectable_max_value_counted(gems: int, acorns: int, carrots: int) -> void:
	_max_collected = carrots + acorns + gems


func _on_Level_completion_time_emitted(time: float) -> void:
	_elapsed_time = time
