extends Control

export var popup_variance = Vector2(50,10)

var _displayed_score := 0.0

func _ready():
	# warning-ignore:return_value_discarded
	Globals.connect("score_changed", self, "_on_Globals_score_changed")


func _process(_delta):
	_displayed_score = lerp(_displayed_score, Globals.score, 0.4)
	$ScoreLabel.text = str(int(ceil(_displayed_score)))


func _on_Globals_score_changed(points:int)->void:
	var popup_label := preload("res://UI/ScoreFeedbackPopup.tscn").instance()
	$"%FeedbackLocation".add_child(popup_label)
	popup_label.text = "+%d" % points
	
	# To prevent them all showing up in the same place, we'll be a little 
	# variation into the initial positions.
	var x = randf() * popup_variance.x - popup_variance.x/2
	var y = randf() * popup_variance.y - popup_variance.y/2
	popup_label.position = Vector2(x,y)
