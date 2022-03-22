extends Node2D

var data := {
	"Move": {"max_speed_default": Vector2(150, 675), "max_dash_count": 0},
	"Move/Air": {"jump_impulse": 500}
}

onready var skin := $Skin
