extends Node2D

export var variance_degrees := 5.0
export var hertz := 1.0

onready var _original_rotation := global_rotation


func _process(_delta):
	global_rotation_degrees = sin(Globals.elapsed_audio*hertz) * variance_degrees
