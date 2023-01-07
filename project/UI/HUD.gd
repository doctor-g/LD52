extends Control


func _process(_delta):
	$ScoreLabel.text = str(Globals.score)
