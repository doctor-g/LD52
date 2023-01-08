extends Control


func _on_EasyButton_pressed():
	_play(preload("res://Game/EasyGame.tscn"))


func _on_MidButton_pressed():
	_play(preload("res://Game/MidGame.tscn"))


func _play(scene:PackedScene)->void:
	_disable_buttons()
	$ButtonSound.play()
	yield($ButtonSound, "finished")
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scene)


func _disable_buttons()->void:
	$"%EasyButton".disconnect("pressed", self, "_on_EasyButton_pressed")
	$"%MidButton".disconnect("pressed", self, "_on_MidButton_pressed")
