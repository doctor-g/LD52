extends Control

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
	yield(get_tree().create_timer(0.5), "timeout")
	popup_label.queue_free()
