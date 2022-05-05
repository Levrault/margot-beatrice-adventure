extends AudioStreamPlayer

const TRANSITION_DURATION := 0.5

var playlist := {
	"assassin": "res://assets/music/Assassin.ogg",
	"child_nightmare": "res://assets/music/Child\'s Nightmare.ogg",
	"common_fight": "res://assets/music/Common Fight.ogg",
	"electronic_fantasy": "res://assets/music/Electronic Fantasy.ogg",
	"friends": "res://assets/music/Friends.ogg",
	"lyonesse": "res://assets/music/Lyonesse.ogg",
	"mall": "res://assets/music/Mall.ogg",
	"su_turno": "res://assets/music/Su Turno.ogg",
	"the_three_princesses_of_lilac_meadows":
	"res://assets/music/The Three Princesses of Lilac Meadow.ogg",
	"yellow_forest": "res://assets/music/Yellow Forest.ogg",
}

var current: String = "mall"

onready var tween := $Tween


func change_track(new_music: String) -> void:
	if new_music == current:
		return
	stop()
	current = playlist[new_music]
	stream = load(current)
	transition()


func transition() -> void:
	tween.interpolate_property(
		self, "volume_db", -80, 0, TRANSITION_DURATION, Tween.EASE_IN, Tween.TRANS_LINEAR
	)
	tween.start()
	play()
