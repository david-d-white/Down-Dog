extends Control

func _process(delta):
	if Input.is_action_just_pressed("movement_jump"):
		get_tree().change_scene("res://assets/Scenes/Intro.tscn")
