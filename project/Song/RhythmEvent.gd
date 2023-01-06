class_name RhythmEvent
extends Object

# Time of the event in milliseconds
var time : int

# The expected action event name
var action : String


func _init(time_:int, action_:String):
	time = time_
	action = action_
