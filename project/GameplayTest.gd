extends Node

const bpm := 120

var EVENTS := [
	{
		"time": 1000,
	},
	{
		"time": 1500
	}
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

	# We hit a key, so is it right or wrong?
	if Input.is_action_just_pressed("test_trigger"):
		if position > next_event.time - tolerance or position < next_event.time + tolerance:
			print("GOT IT")
			_next_event_index += 1
		else:
			print("Missed it, but you can try again without killing this event")
	
