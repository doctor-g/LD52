extends Control

const MainMenu = preload("res://UI/MainMenuScreen.tscn")

func _ready():
	if OS.get_name() != "HTML5":
		_go_to_main_menu()
	

func _on_ReadyButton_pressed():
	_go_to_main_menu()


func _go_to_main_menu()->void:
	$ReadyButton.disconnect("pressed", self, "_on_ReadyButton_pressed")
	$ButtonSound.play()
	yield($ButtonSound, "finished")
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(MainMenu)
