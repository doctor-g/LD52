extends Node

# How many seconds of the audio have played
var elapsed_audio : float

# How accurate has the player to be, in seconds
var tolerance := 0.1

var score := 0 

# The scale of the application's elements and speed.
# This is "pixels per second of audio duration".
var pixels_per_second := 500
