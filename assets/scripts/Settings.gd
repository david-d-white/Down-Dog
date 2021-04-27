extends Control

export (PackedScene) var Main_Menu

func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_Back_pressed():
	get_tree().change_scene("res://assets/Scenes/Menu.tscn")
