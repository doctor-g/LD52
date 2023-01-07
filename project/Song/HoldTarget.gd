extends Node2D
class_name HoldTarget

enum State { PENDING, STARTED, SUCCEEDED, FAILED  }

var action : String
var start_time : float
var end_time : float

var _state = State.PENDING

export var radius := 30

func _ready():
	assert(action!=null)
	assert(end_time!=0)
	
	$Label.text = action.substr(3) # Kludge for "ui_" labels


func _process(_delta):
	if _state==State.PENDING:
		if Input.is_action_just_pressed(action) and _in_tolerance(start_time):
			_set_state(State.STARTED)
		elif Globals.elapsed_audio > Globals.tolerance + start_time:
			_set_state(State.FAILED)
	
	if _state==State.STARTED:
		if Input.is_action_just_released(action):
			if _in_tolerance(end_time):
				# Released on time
				_set_state(State.SUCCEEDED)
			else:
				# Released too early
				_set_state(State.FAILED)
		elif Globals.elapsed_audio > Globals.tolerance + end_time:
			# Missed the release
			_set_state(State.FAILED)


func _in_tolerance(time:float)->bool:
	return abs(time-Globals.elapsed_audio) <= Globals.tolerance


func _set_state(new_state)->void:
	_state = new_state
	update()


func _draw():
	var color : Color
	match _state:
		State.PENDING:
			color = Color.gray
		State.STARTED: 
			color = Color.yellow
		State.FAILED:
			color = Color.red
		State.SUCCEEDED:
			color = Color.green
	
	var width := (end_time - start_time) * 1000 # Assuming 1ms=1pixel
	draw_rect(Rect2(0, -radius, width, radius*2), color)
	draw_circle(Vector2.ZERO, radius, color)
	draw_circle(Vector2(width, 0), radius, color)
