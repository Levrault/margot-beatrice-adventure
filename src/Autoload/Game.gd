extends Node

var current_profile := "profile0"
var current_level := ""
var splash_screen_viewed := false

var unlocked_characters := {
	"fox": true,
	"squirrel": false,
	"rabbit": false,
}

# stats per level
var stats := {"game_over": 0, "hits_taken": 0}
var rank := {
	"S": {"value": 3, "text": "S"},
	"A": {"value": 2, "text": "A"},
	"B": {"value": 1, "text": "B"},
	"C": {"value": 0, "text": "C"}
}


func reset() -> void:
	stats.game_over = 0
	stats.hits_taken = 0
