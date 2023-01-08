extends Node2D

var text : String setget _set_text

func _set_text(value:String)->void:
	$Label.text = value
