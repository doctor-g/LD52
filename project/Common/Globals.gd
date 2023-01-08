extends Node

signal score_changed(points)

# How many seconds of the audio have played
var elapsed_audio : float

# How accurate has the player to be, in seconds
var tolerance := 0.1

# Accuracy required for the special bonus
var accuracy_tolerance := 0.02

var score := 0 setget _set_score

# The scale of the application's elements and speed.
# This is "pixels per second of audio duration".
var pixels_per_second := 500


func reset()->void:
	score = 0
	elapsed_audio = 0


func _set_score(value:int)->void:
	var old_score := score
	score = value
	emit_signal("score_changed", score - old_score)
