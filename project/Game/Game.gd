extends Node

const DATA := [
	[1, 1, "ui_up"],
	[1, 3, "ui_down"],
	[2, 1, "ui_up"],
	[2, 3, "ui_down"]
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

func _ready():
	_start_ticks = Time.get_ticks_msec()
	
	var seconds_per_beat := 1.0 / tempo * 60
	print("Seconds per beat: " + str(seconds_per_beat))
	
	# The duration of one measure in milliseconds
	var lead_in_duration := beats_per_measure * seconds_per_beat * 1000
	print("lead in duration " + str(lead_in_duration))
	
	for datum in DATA:
		var measure : int = datum[0]
		var beat_of_measure : int = datum[1]
		var action : String = datum[2]
		
		var beat_of_song : int = (measure-1) * beats_per_measure + beat_of_measure
		print("Beat of song " + str(beat_of_song))
		# warning-ignore:narrowing_conversion
		var time : int = (beat_of_song-1) * seconds_per_beat * 1000
		
		print("Time: " + str(time))
		
		var event := RhythmEvent.new(time, action)
		_events.append(event)
		
		var target = _RhythmTarget.instance()
		target.position = Vector2(event.time + lead_in_duration, 0)
		target.event = event
		$TargetArea.add_child(target)
	
	# Wait the duration of one measure
	yield(get_tree().create_timer(lead_in_duration / 1000), "timeout")
	$AudioStreamPlayer.play()



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
			if Input.is_action_just_pressed(action_name):
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
