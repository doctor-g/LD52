extends Node

const bpm := 120

var EVENTS := [
	RhythmEvent.new(1000, "ui_up"),
	RhythmEvent.new(1500, "ui_up"),
	RhythmEvent.new(2000, "ui_up")
]

# Tolerance in milliseconds
export var tolerance := 200

var _start_ticks : int
var _next_event_index := 0

func _ready():
	_start_ticks = Time.get_ticks_msec()
	

func _process(_delta):
	# Get the position in the stream in milliseconds
	var position = $AudioStreamPlayer.get_playback_position() * 1000
	
	# If there are no more events, just exit
	if _next_event_index >= EVENTS.size():
		return
	
	var next_event = EVENTS[_next_event_index]
	
	# Did we miss one?
	if position > next_event.time + tolerance:
		print("MISSED ONE")
		_next_event_index += 1
		return

	# Are we in the window of the next event?
	if next_event.time - tolerance <= position:
		# Did we just hit the right input?
		for action_name in ["ui_up", "ui_down", "ui_left", "ui_right"]:
			if Input.is_action_just_pressed(action_name):
				if next_event.action == action_name:
					print("GOT IT")
					_next_event_index += 1
				else:
					print("WRONG ACTION")
					_next_event_index += 1
	else:
		# No action is expected here, but maybe they hit one
		for action_name in ["ui_up", "ui_down", "ui_left", "ui_right"]:
			if Input.is_action_just_pressed(action_name):
				print("You hit an action but none was expected here")
