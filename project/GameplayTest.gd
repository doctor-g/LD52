extends Node

const bpm := 120

# Tolerance in seconds
export var tolerance = 0.2

var _start_ticks : int

func _ready():
	_start_ticks = Time.get_ticks_msec()
	

func _process(_delta):
	var position = $AudioStreamPlayer.get_playback_position()
	
	# Probably better to do this with a stream of events. Then, when the action
	# is hit, it can be seen if it is within tolerance of the latest event,
	# or if events are missed, the UI can be updated.
	if Input.is_action_just_pressed("test_trigger"):
		if position < tolerance:
			print("Just after, but good!")
		elif 2.0 - position < tolerance:
			print("Just before, but good!")
		else:
			print("Nope")
