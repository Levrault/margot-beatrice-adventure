extends Node2D

var data := {
	"Move": {"max_speed_default": Vector2(250, 675), "max_dash_count": 1},
	"Move/Air": {"jump_impulse": 520}
}

onready var skin := $Skin
