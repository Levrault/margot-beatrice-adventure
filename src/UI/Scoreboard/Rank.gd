extends Label

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
	var rank: Dictionary = Game.rank.C
	var total_collected := 0
	for key in Character.score:
		total_collected += Character.score[key]

	var percentage_collected := compute_percentage(total_collected, _max_collected)

	print_debug("Time for rank (current is %s): S %s | A %s | B %s" % [String(_elapsed_time), String(owner.time_for_rank_100), String(owner.time_for_rank_80), String(owner.time_for_rank_60)])

	# S is 100%
	if (
		percentage_collected == 100
		and Game.stats.game_over == 0
		and Game.stats.hits_taken == 0
		and _elapsed_time <= owner.time_for_rank_100
	):
		rank = Game.rank.S
	elif (
		percentage_collected >= 80
		and Game.stats.game_over <= 1
		and Game.stats.hits_taken <= 5
		and _elapsed_time <= owner.time_for_rank_80
	):
		rank = Game.rank.A
	elif (
		percentage_collected >= 60
		and Game.stats.game_over <= 2
		and Game.stats.hits_taken <= 10
		and _elapsed_time <= owner.time_for_rank_60
	):
		rank = Game.rank.B

	text = rank.text

	print_debug(
		(
			"Level completed: time %s | percentage collected %s | hits_taken %s | gameover %s | rank %s"
			% [
				String(_elapsed_time),
				String(percentage_collected),
				String(Game.stats.hits_taken),
				String(Game.stats.game_over),
				rank.text
			]
		)
	)

	Serialize.save_best_score(
		Game.current_profile,
		owner.current_level,
		{
			"gems": Character.score[Character.Playable.FOX],
			"carrots": Character.score[Character.Playable.RABBIT],
			"acorns": Character.score[Character.Playable.SQUIRREL],
			"rank": rank.text,
			"hits": Game.stats.hits_taken,
			"game_over": Game.stats.game_over,
			"best_time": _elapsed_time,
			"locked": false
		}
	)

	Serialize.save_global_stats(
		Game.current_profile,
		Game.stats,
		_elapsed_time
	)

	if owner.unlock_next_level:
		Serialize.unlock_next_level(Game.current_profile, owner.next_level)


func compute_percentage(value, max_value) -> int:
	var percentage = value * 100 / max_value if value > 0 else 0
	return int(round(percentage))


func _on_Collectable_max_value_counted(gems: int, acorns: int, carrots: int) -> void:
	_max_collected = carrots + acorns + gems


func _on_Level_completion_time_emitted(time: float) -> void:
	_elapsed_time = time
