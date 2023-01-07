extends Node

# Format:
#  [ measure, beat of measure to press, action, beats later to release ]
const DATA := [
	[1, 1, "ui_up", 1],
	[1, 3, "ui_down", 1],
	[2, 1, "ui_up", 1],
	[2, 3, "ui_down", 1]
]

# Tolerance in seconds
export var tolerance := 0.1

# Beats per MINUTE
export var tempo := 90

# Beats per MEASURE
export var beats_per_measure := 4

# The list of rhythm target events.
# Created by the _ready() function.
var _events := []

var _next_event_index := 0

# In seconds
var _lead_in_duration : float

# If we are currently holding for a target, this is it.
# If this is null, we are not currently holding for a target
var _current_target : Node2D


func _ready():
	var seconds_per_beat := 1.0 / tempo * 60
	
	# Set lead-in to the duration of one measure in seconds
	# Or comment this out to test faster
	_lead_in_duration = beats_per_measure * seconds_per_beat
	
	for datum in DATA:
		var measure : int = datum[0]
		var beat_of_measure : int = datum[1]
		var action : String = datum[2]
		var beats_until_release : int = datum[3]
		
		var beat_of_song := (measure-1) * beats_per_measure + beat_of_measure
		var start_time := (beat_of_song-1) * seconds_per_beat
		var end_time := start_time + beats_until_release * seconds_per_beat
		
		var target := preload("res://Song/HoldTarget.tscn").instance() as HoldTarget
		target.action = action
		target.start_time = start_time
		target.end_time = end_time
		# By default, they should not process. This is so that we can wait
		# for the lead-in. Unfortunately, set_process did not work right here,
		# so we use a state variable instead
		target.active = false
		
		$TargetArea.add_child(target)
		target.position = Vector2((start_time+_lead_in_duration)*Globals.pixels_per_second, 0)
		
	# Set the next target to the first one
	_next_target = $TargetArea.get_child(0)
	
	# Wait for the lead in, but start listening for events within tolerance.
	yield(get_tree().create_timer(_lead_in_duration - tolerance), "timeout")
	for target in $TargetArea.get_children():
		target.active = true
	yield(get_tree().create_timer(tolerance), "timeout")
	$AudioStreamPlayer.play()

var _next_target : HoldTarget = null
var _next_target_index := 0


func _process(delta):
	$TargetArea.position.x -= delta * Globals.pixels_per_second
	
	# Get the position in the stream in seconds
	# Update the global value
	Globals.elapsed_audio = $AudioStreamPlayer.get_playback_position()
