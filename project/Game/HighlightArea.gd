extends Node2D
tool


func _draw():
	var tolerance : float
	var pixels_per_second : float
	
	# This is a tool so it can draw itself, but we cannot be sure
	# that Globals is initialized before draw is called. Hence,
	# if running in the editor, we'll just grab the globals default
	# values manually here.
	if Engine.editor_hint:
		var globals = load("res://Common/Globals.gd").new()
		tolerance = globals.tolerance
		pixels_per_second = globals.pixels_per_second
	else:
		tolerance = Globals.tolerance
		pixels_per_second = Globals.pixels_per_second
	
	var radius := tolerance * pixels_per_second
	draw_circle(Vector2.ZERO, radius, Color.white)
