extends Node

# Format:
#  [ measure, beat of measure to press, action, beats later to release ]
const DATA := [
	[1, 1, "ui_up", 1],
	[1, 3, "ui_down", 1],
	[2, 1, "ui_up", 1],
	[2, 3, "ui_down", 1]
]

const _RhythmTarget := preload("res://Song/RhythmTarget.tscn")

# Tolerance in milliseconds
export var tolerance := 100

# Beats per MINUTE
export var tempo := 90

# Beats per MEASURE
export var beats_per_measure := 4

# The list of rhythm target events.
# Created by the _ready() function.
var _events := []

var _start_ticks : int
var _next_event_index := 0
var _seconds_per_beat : float
var _lead_in_duration : float

func _ready():
	_start_ticks = Time.get_ticks_msec()
	_seconds_per_beat = 1.0 / tempo * 60
	
	# Set lead-in to the duration of one measure in milliseconds
	_lead_in_duration = beats_per_measure * _seconds_per_beat * 1000
	
	for datum in DATA:
		var measure : int = datum[0]
		var beat_of_measure : int = datum[1]
		var action : String = datum[2]
		var release : int = datum[3]
		
		var beat_of_song : int = (measure-1) * beats_per_measure + beat_of_measure
		
		_create_event(beat_of_song, action, RhythmEvent.PRESS)
		_create_event(beat_of_song + release, action, RhythmEvent.RELEASE)
	
	# Wait the duration of one measure
	yield(get_tree().create_timer(_lead_in_duration / 1000), "timeout")
	$AudioStreamPlayer.play()


func _create_event(beat_of_song:int, action:String, type)->void:
	# warning-ignore:narrowing_conversion
	var time : int = (beat_of_song-1) * _seconds_per_beat * 1000
	var event := RhythmEvent.new(time, action, type)
	_events.append(event)
		
	var target = _RhythmTarget.instance()
	target.position = Vector2(event.time + _lead_in_duration, 0)
	target.event = event
	$TargetArea.add_child(target)


func _process(delta):
	$TargetArea.position.x -= delta * 1000 # Later, this should relate to bpm
	
	# Get the position in the stream in milliseconds
	var position = $AudioStreamPlayer.get_playback_position() * 1000
	
	# If there are no more events, just exit
	if _next_event_index >= _events.size():
		return
	
	var next_event = _events[_next_event_index]
	var next_target = $TargetArea.get_child(_next_event_index)
	
	# Did we miss one?
	if position > next_event.time + tolerance:
		print("MISSED ONE")
		next_target.miss()
		_next_event_index += 1
		return

	# Are we in the window of the next event?
	if next_event.time - tolerance <= position:
		# Did we just hit the right input?
		for action_name in ["ui_up", "ui_down", "ui_left", "ui_right"]:
			if _does_action_match(action_name, next_event.type):
				if next_event.action == action_name:
					print("GOT IT")
					next_target.hit()
					_next_event_index += 1
				else:
					next_target.miss()
					print("WRONG ACTION")
					_next_event_index += 1
	else:
		# No action is expected here, but maybe they hit one
		for action_name in ["ui_up", "ui_down", "ui_left", "ui_right"]:
			if Input.is_action_just_pressed(action_name):
				print("You hit an action but none was expected here")


func _does_action_match(action:String, type)->bool:
	return (type == RhythmEvent.PRESS and Input.is_action_just_pressed(action)) \
		or (type == RhythmEvent.RELEASE and Input.is_action_just_released(action))
