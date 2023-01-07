extends Control

var _displayed_score := 0.0

func _process(_delta):
	_displayed_score = lerp(_displayed_score, Globals.score, 0.4)
	$ScoreLabel.text = str(int(ceil(_displayed_score)))
