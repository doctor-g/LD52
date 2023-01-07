extends Control


func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(preload("res://Game/Game.tscn"))
