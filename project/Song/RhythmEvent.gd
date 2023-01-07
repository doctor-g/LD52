class_name RhythmEvent
extends Object

enum { PRESS, RELEASE }

# Time of the event in milliseconds
var time : int

# The expected action event name
var action : String

# Either PRESS or RELEASE
var type 


func _init(time_:int, action_:String, type_):
	assert(type_ == PRESS or type_ == RELEASE)
	time = time_
	action = action_
	type = type_
