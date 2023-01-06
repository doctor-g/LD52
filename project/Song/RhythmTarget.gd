extends Node2D

enum State { HIT, MISSED, PENDING }

var _state = State.PENDING

var event : RhythmEvent

export var radius := 30

func _ready():
	assert(event!=null, "Don't forget to set the event!")
	$Label.text = event.action.substr(3)


func hit()->void:
	_state = State.HIT
	update()


func miss()->void:
	_state = State.MISSED
	update()
	

func _draw():
	var color : Color
	match _state:
		State.HIT: 
			color = Color.green
		State.MISSED:
			color = Color.red
		State.PENDING:
			color = Color.yellow
	
	draw_circle(Vector2.ZERO, radius, color)
