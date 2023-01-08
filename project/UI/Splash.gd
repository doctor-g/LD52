extends Control

const MainMenu = preload("res://UI/MainMenuScreen.tscn")

func _ready():
	if OS.get_name() != "HTML5":
		_go_to_main_menu()
	

func _on_ReadyButton_pressed():
	_go_to_main_menu()


func _go_to_main_menu()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(MainMenu)
