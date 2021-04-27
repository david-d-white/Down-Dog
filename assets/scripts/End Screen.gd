extends Control

func _ready():
	if PlayerStats.player_health > 0:
		$MarginContainer/Controls.text = """		  CONGRATULATIONS
			Time: %.2fs
		
		<SPACE TO CONTINUE>""" % PlayerStats.speedrun_time
	else:
		$MarginContainer/Controls.text = """		     GAME OVER
		
		<SPACE TO CONTINUE>"""

func _process(delta):
	if Input.is_action_just_pressed("movement_jump"):
		get_tree().change_scene("res://assets/Scenes/Menu.tscn")
