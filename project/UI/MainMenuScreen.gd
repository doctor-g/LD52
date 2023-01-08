extends Control


func _on_PlayButton_pressed():
	$PlayButton.disconnect("pressed", self, "_on_PlayButton_pressed")
	$ButtonSound.play()
	yield($ButtonSound, "finished")
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(preload("res://Game/Game.tscn"))
