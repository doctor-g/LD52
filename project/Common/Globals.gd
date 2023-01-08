extends Node

# How many seconds of the audio have played
var elapsed_audio : float

# How accurate has the player to be, in seconds
var tolerance := 0.1

# Accuracy required for the special bonus
var accuracy_tolerance := 0.02

var score := 0 

# The scale of the application's elements and speed.
# This is "pixels per second of audio duration".
var pixels_per_second := 500


func reset()->void:
	score = 0
	elapsed_audio = 0
