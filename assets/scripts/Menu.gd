extends Control

func _on_Play_pressed():
	get_tree().change_scene("res://assets/Scenes/Controls.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://assets/Scenes/Settings.tscn")

func _on_Quit_pressed():
	get_tree().quit()
