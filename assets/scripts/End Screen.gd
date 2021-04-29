extends Control

func _ready():
	if PlayerStats.player_health > 0:
		$MarginContainer/Message.text = """		  CONGRATULATIONS
			Time: %.2fs""" % PlayerStats.speedrun_time
	else:
		$MarginContainer/Message.text = """		     GAME OVER"""

func _input(event):
	if event.is_pressed():
		get_tree().change_scene("res://assets/Scenes/Menu.tscn")
