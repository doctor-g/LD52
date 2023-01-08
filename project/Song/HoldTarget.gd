extends Node2D
class_name HoldTarget

const action_symbol_map = {
	"up": "↑",
	"down": "↓",
	"left": "←",
	"right": "→"
}

enum State { PENDING, STARTED, SUCCEEDED, FAILED  }

enum OtherActionState { STARTED, FINISHED }

# Points for starting at the right time
export var start_points := 15
# Points for ending at the right time
export var end_points := 15

# Bonus points for extreme accuracy
export var accuracy_bonus := 10

# Points earned for pressing a separate action the first time
export var novel_other_action_points := 10

# Points earned for pressing a separate action subsequent times
export var repeat_other_action_points := 1

var action : String
var start_time : float
var end_time : float

var _state = State.PENDING

# The array of _other_ actions that are possible for points
var _other_actions := ["up", "down", "left", "right"]

# If there is no value for a key, it has not been used.
# If the value is STARTED, it's pressed.
# If it's FINISHED, it's completed.
var _other_action_states = {}

export var radius := 30

func _ready():
	assert(action!=null)
	assert(end_time!=0)
	
	$Label.text = action_symbol_map[action]
	
	# Remove this action so that the other actions list is accurate.
	_other_actions.remove(_other_actions.find(action))


func _process(_delta):
	if _state==State.PENDING:
		if Input.is_action_just_pressed(action) and _in_tolerance(start_time):
			_set_state(State.STARTED)
			var points = start_points + accuracy_bonus if _in_bonus_tolerance(start_time) else start_points
			Globals.score += points
		elif Globals.elapsed_audio > Globals.tolerance + start_time:
			_set_state(State.FAILED)
	
	if _state==State.STARTED:
		if Input.is_action_just_released(action):
			if _in_tolerance(end_time):
				# Released on time
				_set_state(State.SUCCEEDED)
				var points = end_points + accuracy_bonus if _in_bonus_tolerance(end_time) else end_points
				Globals.score += points
			else:
				# Released too early
				_set_state(State.FAILED)
		elif Globals.elapsed_audio > Globals.tolerance + end_time:
			# Missed the release
			_set_state(State.FAILED)
		
		# Check the other actions
		for other in _other_actions:
			if Input.is_action_just_pressed(other):
				# Only earn max points if this is the first use
				if not other in _other_action_states:
					Globals.score += novel_other_action_points
					$ExtraSuccessSound.play()
				else:
					Globals.score += repeat_other_action_points
				_other_action_states[other] = OtherActionState.STARTED

			elif Input.is_action_just_released(other) \
				and other in _other_action_states \
				and _other_action_states[other]==OtherActionState.STARTED:
				_other_action_states[other] = OtherActionState.FINISHED


func _in_tolerance(time:float)->bool:
	return abs(time-Globals.elapsed_audio) <= Globals.tolerance


func _in_bonus_tolerance(time:float)->bool:
	return abs(time-Globals.elapsed_audio) <= Globals.accuracy_tolerance


func _set_state(new_state)->void:
	_state = new_state
	match _state:
		State.FAILED:
			$MissSound.play()
		State.STARTED:
			$SuccessSound.play()
		State.SUCCEEDED:
			$SuccessSound.play()
	
	# Force a redraw to get the new colors
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
	
	var width := (end_time - start_time) * Globals.pixels_per_second
	var border := 5.0
	var border_color := Color.sienna
	
	draw_circle(Vector2.ZERO, radius, border_color)
	draw_circle(Vector2.ZERO, radius-border, color)
	
	draw_circle(Vector2(width, 0), radius, border_color)
	draw_circle(Vector2(width, 0), radius-border, color)
	
	draw_rect(Rect2(0, -radius, width, radius*2), border_color)
	draw_rect(Rect2(0, -radius+border, width, (radius-border)*2), color)
