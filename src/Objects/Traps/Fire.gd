extends StaticBody2D

onready var _player_detector := $PlayerDetector
onready var _damage_source := $DamageSource
onready var _anim := $AnimationPlayer


func _ready():
	_player_detector.connect("player_entered", self, "_on_Player_entered")
	_player_detector.connect("player_exited", self, "_on_Player_exited")
	_anim.connect("animation_finished", self, "_on_Animation_finished")


func _on_Player_entered(body: Player) -> void:
	_anim.play("hit")


func _on_Player_exited(body: Player) -> void:
	_damage_source.is_active = false

	# player has exited while hit was playing
	if _anim.current_animation == "hit":
		_anim.play("hit", -1, -1.0, false)
	else:
		# on was player
		_anim.play_backwards("hit")
	_anim.queue("off")


func _on_Animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		_anim.play("on")
		_damage_source.is_active = true
