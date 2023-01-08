extends Control

export var popup_variance = Vector2(50,10)

var _displayed_score := 0.0
var _scene_path : String

func _ready():
	# warning-ignore:return_value_discarded
	Globals.connect("score_changed", self, "_on_Globals_score_changed")


func _process(_delta):
	_displayed_score = lerp(_displayed_score, Globals.score, 0.4)
	$ScoreLabel.text = str(int(ceil(_displayed_score)))


func show_menu(caller:Node)->void:
	$Buttons.visible = true
	_scene_path = caller.filename


func _on_Globals_score_changed(points:int)->void:
	var popup_label := preload("res://UI/ScoreFeedbackPopup.tscn").instance()
	$"%FeedbackLocation".add_child(popup_label)
	popup_label.text = "+%d" % points
	
	# To prevent them all showing up in the same place, we'll be a little 
	# variation into the initial positions.
	var x = randf() * popup_variance.x - popup_variance.x/2
	var y = randf() * popup_variance.y - popup_variance.y/2
	popup_label.position = Vector2(x,y)


func _on_PlayAgainButton_pressed()->void:
	_go_to_scene(_scene_path)


func _on_MainMenuButton_pressed()->void:
	_go_to_scene("res://UI/MainMenuScreen.tscn")


func _go_to_scene(path:String)->void:
	$"%PlayAgainButton".disconnect("pressed", self, "_on_PlayAgainButton_pressed")
	$"%MainMenuButton".disconnect("pressed", self, "_on_MainMenuButton_pressed")
	$ButtonSound.play()
	yield($ButtonSound, "finished")
	Globals.reset()
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene(path)
