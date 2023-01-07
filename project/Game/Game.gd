extends Node


# Tolerance in seconds
export var tolerance := 0.1

# Beats per MINUTE
export var tempo := 90

# Beats per MEASURE
export var beats_per_measure := 4

var _next_target : HoldTarget = null


func _ready():
	var inputs := ["up", "down", "left", "right"]
	
	# Rather than hardcode it, the data can be generated. The easy song
	# is eight measures, with a one measure lead-in, 
	# and we'll do things on beats 1 and 3
	#
	# Data Format:
	#  [ measure, beat of measure to press, action, beats later to release ]
	var DATA = []
	for measure in range(2, 10): # Measures 2-9 with the lead-in
		var input : String = inputs[randi() % inputs.size()]
		DATA.append([measure, 1, input, 1])
		DATA.append([measure, 3, input, 1])
	
	
	var seconds_per_beat := 1.0 / tempo * 60
	
	for datum in DATA:
		var measure : int = datum[0]
		var beat_of_measure : int = datum[1]
		var action : String = datum[2]
		var beats_until_release : int = datum[3]
		
		var beat_of_song := (measure-1) * beats_per_measure + beat_of_measure
		var start_time := (beat_of_song-1) * seconds_per_beat
		var end_time := start_time + beats_until_release * seconds_per_beat
		
		var target := preload("res://Song/HoldTarget.tscn").instance() as HoldTarget
		target.action = action
		target.start_time = start_time
		target.end_time = end_time
		
		$"%TargetArea".add_child(target)
		target.position = Vector2(start_time*Globals.pixels_per_second, 0)
		
	# Set the next target to the first one
	_next_target = $"%TargetArea".get_child(0)
	
	$AudioStreamPlayer.play()


func _process(delta):
	$"%TargetArea".position.x -= delta * Globals.pixels_per_second
	Globals.elapsed_audio = $AudioStreamPlayer.get_playback_position()


func _on_AudioStreamPlayer_finished():
	$"%PlayAgainButton".visible = true


func _on_PlayAgainButton_pressed():
	Globals.reset()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Game/Game.tscn")
