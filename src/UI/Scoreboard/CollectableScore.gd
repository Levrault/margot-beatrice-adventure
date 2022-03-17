extends HBoxContainer

export (Character.Playable) var selected = Character.Playable.FOX

onready var _score := $ScoreContainer/Score
onready var _max_value := $ScoreContainer/MaxScore
onready var _tween = $Tween
onready var _sfx := $SFXCollectable


func _ready():
	Events.connect("collectable_max_value_counted", self, "_on_Collectable_max_value_counted")


func _on_Collectable_max_value_counted(gems: int, acorns: int, carrots: int) -> void:
	if selected == Character.Playable.FOX:
		_max_value.text = String(gems)
		return
	if selected == Character.Playable.SQUIRREL:
		_max_value.text = String(acorns)
		return
	if selected == Character.Playable.RABBIT:
		_max_value.text = String(carrots)
		return


func start_tween() -> void:
	_tween.interpolate_method(
		self,
		"_format_text",
		0,
		Character.score[selected],
		.5,
		Tween.TRANS_LINEAR,
		Tween.TRANS_LINEAR
	)
	_tween.start()
	_sfx.play()


func _format_text(value: int) -> void:
	_score.text = String(value)
