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

var _start_ticks : int
var _next_event_index := 0
var _lead_in_duration : float

# If we are currently holding for a target, this is it.
# If this is null, we are not currently holding for a target
var _current_target : Node2D


func _ready():
	_start_ticks = Time.get_ticks_msec()
	var seconds_per_beat := 1.0 / tempo * 60
	
	# Set lead-in to the duration of one measure in milliseconds
	# Or comment this out to test faster
	_lead_in_duration = beats_per_measure * seconds_per_beat * 1000
	
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
		
		$TargetArea.add_child(target)
		target.position = Vector2(start_time*1000 + _lead_in_duration, 0)
		
	# Set the next target to the first one
	_next_target = $TargetArea.get_child(0)
	
	# Wait the duration of one measure
	yield(get_tree().create_timer(_lead_in_duration / 1000), "timeout")
	$AudioStreamPlayer.play()

var _next_target : HoldTarget = null
var _next_target_index := 0


func _process(delta):
	$TargetArea.position.x -= delta * 1000 # Later, this should relate to bpm and scale
	
	# Get the position in the stream in seconds
	# Update the global value
	Globals.elapsed_audio = $AudioStreamPlayer.get_playback_position()
