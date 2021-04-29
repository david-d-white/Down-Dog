extends Control

export (PackedScene) var Main_Menu

onready var input_mode = $MarginContainer/CenterContainer/VBoxContainer/InputMode

func _ready():
	_on_input_mode_changed()
	GlobalSettings.connect("input_mode_changed", self, "_on_input_mode_changed")
	$MarginContainer/CenterContainer/VBoxContainer/Fullscreen.grab_focus()

func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_Back_pressed():
	get_tree().change_scene("res://assets/Scenes/Menu.tscn")

func _on_input_mode_changed():
	input_mode.text = GlobalSettings.InputModes.keys()[GlobalSettings.input_mode]

func _on_InputMode_pressed():
	GlobalSettings.input_mode += 1
	if GlobalSettings.input_mode >= GlobalSettings.InputModes.size():
		GlobalSettings.input_mode = 0
	input_mode.text = GlobalSettings.InputModes.keys()[GlobalSettings.input_mode]
