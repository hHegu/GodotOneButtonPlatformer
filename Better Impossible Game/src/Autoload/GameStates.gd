extends Node

signal score_updated
signal player_died
signal level_complete

var score: = 0 setget set_score
var deaths: = 0 setget set_death

func reset() -> void:
	score = 0
	deaths = 0

func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")

func set_death(value: int) -> void:
	deaths = value
	emit_signal("player_died")
	
func level_complete() -> void:
	emit_signal("level_complete")
